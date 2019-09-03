using DinkToPdf;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using ReportingService.Processor.Domain.Entities.KeyVault;
using ReportingService.Processor.Domain.Entities.MongoDB;
using ReportingService.Processor.Domain.Entities.Queue;
using ReportingService.Processor.Domain.Enums;
using ReportingService.Processor.Domain.Exceptions;
using ReportingService.Processor.Domain.Responses;
using ReportingService.Processor.Helpers;
using System;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace ReportingService.Processor
{
    internal class Program
    {
        // AutoResetEvent to signal when to exit the application
        private static readonly AutoResetEvent waitHandle = new AutoResetEvent(false);

        private static MongoDBConnectionInfo mongoDBConnectionInfo = null;
        private static KeyVaultConnectionInfo keyVaultConnectionInfo = null;
        private static string secret = string.Empty;
        private static PdfTools pdfTools = null;
        private static SynchronizedConverter converter = null;

        private static void Init()
        {
            var builder = new ConfigurationBuilder()
            .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
            .AddJsonFile("secrets/appsettings.secrets.json", optional: true)
            .AddEnvironmentVariables();

            IConfigurationRoot Configuration = builder.Build();

            // Retrieve configuration from sections
            ApplicationSettings.ConnectionString = Configuration.GetSection("ApplicationSettings:ConnectionString")?.Value;
            ApplicationSettings.DatabaseId = Configuration.GetSection("ApplicationSettings:DatabaseId")?.Value;
            ApplicationSettings.ReportCollection = Configuration.GetSection("ApplicationSettings:ReportCollection")?.Value;
            ApplicationSettings.RabbitMQUsername = Configuration.GetSection("ApplicationSettings:RabbitMQUsername")?.Value;
            ApplicationSettings.RabbitMQPassword = Configuration.GetSection("ApplicationSettings:RabbitMQPassword")?.Value;
            ApplicationSettings.RabbitMQHostname = Configuration.GetSection("ApplicationSettings:RabbitMQHostname")?.Value;
            ApplicationSettings.RabbitMQPort = Convert.ToInt16(Configuration.GetSection("ApplicationSettings:RabbitMQPort")?.Value);
            ApplicationSettings.DispatchQueueName = Configuration.GetSection("ApplicationSettings:DispatchQueueName")?.Value;
            ApplicationSettings.KeyVaultCertificateName = Configuration.GetSection("ApplicationSettings:KeyVaultCertificateName")?.Value;
            ApplicationSettings.KeyVaultClientId = Configuration.GetSection("ApplicationSettings:KeyVaultClientId")?.Value;
            ApplicationSettings.KeyVaultClientSecret = Configuration.GetSection("ApplicationSettings:KeyVaultClientSecret")?.Value;
            ApplicationSettings.KeyVaultIdentifier = Configuration.GetSection("ApplicationSettings:KeyVaultIdentifier")?.Value;
            ApplicationSettings.KeyVaultEncryptionKey = Configuration.GetSection("ApplicationSettings:KeyVaultEncryptionKey")?.Value;
            ApplicationSettings.SendGridAPIKey = Configuration.GetSection("ApplicationSettings:SendGridAPIKey")?.Value;

            mongoDBConnectionInfo = new MongoDBConnectionInfo()
            {
                ConnectionString = ApplicationSettings.ConnectionString,
                DatabaseId = ApplicationSettings.DatabaseId,
                UserCollection = ApplicationSettings.ReportCollection
            };

            keyVaultConnectionInfo = new KeyVaultConnectionInfo()
            {
                CertificateName = ApplicationSettings.KeyVaultCertificateName,
                ClientId = ApplicationSettings.KeyVaultClientId,
                ClientSecret = ApplicationSettings.KeyVaultClientSecret,
                KeyVaultIdentifier = ApplicationSettings.KeyVaultIdentifier
            };

            using (KeyVaultHelper keyVaultHelper = new KeyVaultHelper(keyVaultConnectionInfo))
            {
                secret = keyVaultHelper.GetVaultKeyAsync(ApplicationSettings.KeyVaultEncryptionKey).Result;
            }

            pdfTools = new PdfTools();
            converter = new SynchronizedConverter(pdfTools);
        }

        private static void Main(string[] args)
        {
            Task.Run(() =>
            {
                try
                {
                    // initialize settings
                    Init();

                    Console.WriteLine($"Processor is now running...");

                    ConnectionFactory factory = new ConnectionFactory();
                    factory.UserName = ApplicationSettings.RabbitMQUsername;
                    factory.Password = ApplicationSettings.RabbitMQPassword;
                    factory.HostName = ApplicationSettings.RabbitMQHostname;
                    factory.Port = ApplicationSettings.RabbitMQPort;
                    factory.RequestedHeartbeat = 60;
                    factory.DispatchConsumersAsync = true;

                    var connection = factory.CreateConnection();
                    var channel = connection.CreateModel();

                    channel.QueueDeclare(queue: ApplicationSettings.DispatchQueueName,
                                    durable: true,
                                    exclusive: false,
                                    autoDelete: false,
                                    arguments: null);

                    channel.BasicQos(prefetchSize: 0, prefetchCount: 1, global: false);

                    var consumer = new AsyncEventingBasicConsumer(channel);
                    consumer.Received += async (model, ea) =>
                    {
                        DispatchResponse response = new DispatchResponse
                        {
                            IsSucceded = true,
                            ResultId = (int)DispatchResponseEnum.Success
                        };

                        // forced-to-disposal
                        Report report = null;
                        PDFHelper pdfHelper = null;
                        MongoDBHelper mongoDBHelper = null;
                        SendGridHelper sendGridHelper = null;

                        try
                        {
                            byte[] body = ea.Body;
                            var message = Encoding.UTF8.GetString(body);

                            var decrypted = string.Empty;
                            decrypted = NETCore.Encrypt.EncryptProvider.AESDecrypt(message, secret);

                            var obj_decrypted = JsonConvert.DeserializeObject<DispatchMessage>(decrypted);

                            //operation id
                            string guid = Guid.NewGuid().ToString();

                            // PDF
                            string pdf = string.Empty;
                            pdfHelper = new PDFHelper();
                            pdf = pdfHelper.Create(guid, converter, obj_decrypted);
                            Console.WriteLine($">> PDF generated successfully");

                            // MongoDB
                            report = new Report();
                            report.fullname = obj_decrypted.Fullname;
                            report.email = obj_decrypted.Email;

                            mongoDBHelper = new MongoDBHelper(mongoDBConnectionInfo);
                            await mongoDBHelper.RegisterReportAsync(report);
                            Console.WriteLine($">> Record saved successfully");

                            // SendGrid
                            sendGridHelper = new SendGridHelper();
                            await sendGridHelper.SendReportEmailAsync(obj_decrypted.Email, obj_decrypted.Fullname, pdf);
                            Console.WriteLine($">> Email: {obj_decrypted.Email} sent successfully");

                            channel.BasicAck(ea.DeliveryTag, false);
                            Console.WriteLine($">> Acknowledgement completed, delivery tag: {ea.DeliveryTag}");
                        }
                        catch (Exception ex)
                        {
                            if (ex is BusinessException)
                            {
                                response.IsSucceded = false;
                                response.ResultId = ((BusinessException)ex).ResultId;

                                string message = EnumDescription.GetEnumDescription((DispatchResponseEnum)response.ResultId);
                                Console.WriteLine($">> Message information: {message}");
                            }
                            else
                            {
                                Console.WriteLine($">> Exception: {ex.Message}, StackTrace: {ex.StackTrace}");

                                if (ex.InnerException != null)
                                {
                                    Console.WriteLine($">> Inner Exception Message: {ex.InnerException.Message}, Inner Exception StackTrace: {ex.InnerException.StackTrace}");
                                }
                            }
                        }
                        finally
                        {
                            report = null;
                            pdfHelper.Dispose();
                            mongoDBHelper.Dispose();
                            sendGridHelper.Dispose();
                        }
                    };

                    string consumerTag = channel.BasicConsume(ApplicationSettings.DispatchQueueName, false, consumer);
                }
                catch (Exception ex)
                {
                    Console.WriteLine($">> Exception: {ex.Message}, StackTrace: {ex.StackTrace}");

                    if (ex.InnerException != null)
                    {
                        Console.WriteLine($">> Inner Exception Message: {ex.InnerException.Message}, Inner Exception StackTrace: {ex.InnerException.StackTrace}");
                    }
                }
            });

            // handle Control+C or Control+Break
            Console.CancelKeyPress += (o, e) =>
            {
                Console.WriteLine("Exit");

                // allow the manin thread to continue and exit...
                waitHandle.Set();
            };

            // wait
            waitHandle.WaitOne();
        }
    }
}