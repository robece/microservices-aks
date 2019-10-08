using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.OpenApi.Models;
using System;

namespace ReportingService.Api
{
    public class Startup
    {
        public Startup(IWebHostEnvironment env)
        {
            var builder = new ConfigurationBuilder()
                .SetBasePath(env.ContentRootPath)
                .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
                .AddJsonFile($"appsettings.{env.EnvironmentName}.json", optional: true)
                .AddJsonFile("secrets/appsettings.secrets.json", optional: true)
                .AddEnvironmentVariables();

            Configuration = builder.Build();
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
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

            // Register the Swagger generator, defining 1 or more Swagger documents
            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new OpenApiInfo { Title = "ReportingService.Api", Version = "v1" });
            });

            services.AddControllers();
            services.AddMvc().AddNewtonsoftJson();

            services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Version_3_0);
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            // Enable middleware to serve generated Swagger as a JSON endpoint.
            app.UseSwagger();

            // Enable middleware to serve swagger-ui (HTML, JS, CSS, etc.),
            // specifying the Swagger JSON endpoint.
            app.UseSwaggerUI(c =>
            {
                c.SwaggerEndpoint("/swagger/v1/swagger.json", "ReportingService.Api V1");
            });

            app.UseHttpsRedirection();

            app.UseRouting();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}