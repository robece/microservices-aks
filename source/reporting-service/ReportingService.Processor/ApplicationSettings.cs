namespace ReportingService.Processor
{
    public class ApplicationSettings
    {
        public static string ConnectionString { get; set; }
        public static string DatabaseId { get; set; }
        public static string ReportCollection { get; set; }
        public static string RabbitMQUsername { get; set; }
        public static string RabbitMQPassword { get; set; }
        public static string RabbitMQHostname { get; set; }
        public static int RabbitMQPort { get; set; }
        public static string DispatchQueueName { get; set; }
        public static string KeyVaultCertificateName { get; set; }
        public static string KeyVaultClientId { get; set; }
        public static string KeyVaultClientSecret { get; set; }
        public static string KeyVaultIdentifier { get; set; }
        public static string KeyVaultEncryptionKey { get; set; }
        public static string SendGridAPIKey { get; set; }
    }
}