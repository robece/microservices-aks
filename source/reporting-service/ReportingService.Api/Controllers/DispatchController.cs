using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using ReportingService.Api.Domain.Entities.KeyVault;
using ReportingService.Api.Domain.Entities.Queue;
using ReportingService.Api.Domain.Enums;
using ReportingService.Api.Domain.Exceptions;
using ReportingService.Api.Domain.Requests;
using ReportingService.Api.Domain.Responses;
using ReportingService.Api.Helpers;
using System;
using System.Threading.Tasks;

// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace ReportingService.Api.Controllers
{
    [Route("api/[controller]")]
    public class DispatchController : Controller
    {
        private readonly ILogger logger = null;

        public DispatchController(ILogger<DispatchController> logger)
        {
            this.logger = logger;
        }

        [HttpPost]
        public async Task<IActionResult> Post([FromBody] DispatchRequest dispatchRequest)
        {
            // non-forced-to-disposal
            DispatchResponse response = new DispatchResponse
            {
                IsSucceded = true,
                ResultId = (int)DispatchResponseEnum.Success
            };

            // forced-to-disposal
            KeyVaultConnectionInfo keyVaultConnectionInfo = null;

            try
            {
                if (string.IsNullOrEmpty(dispatchRequest.Fullname))
                    throw new BusinessException((int)DispatchResponseEnum.FailedEmptyFullname);

                if (string.IsNullOrEmpty(dispatchRequest.Email))
                    throw new BusinessException((int)DispatchResponseEnum.FailedEmptyFullname);

                keyVaultConnectionInfo = new KeyVaultConnectionInfo()
                {
                    CertificateName = ApplicationSettings.KeyVaultCertificateName,
                    ClientId = ApplicationSettings.KeyVaultClientId,
                    ClientSecret = ApplicationSettings.KeyVaultClientSecret,
                    KeyVaultIdentifier = ApplicationSettings.KeyVaultIdentifier
                };

                using (MessageQueueHelper messageQueueHelper = new MessageQueueHelper())
                {
                    DispatchMessage dispatchMessage = new DispatchMessage()
                    {
                        Fullname = dispatchRequest.Fullname,
                        Email = dispatchRequest.Email
                    };

                    await messageQueueHelper.QueueMessageAsync(dispatchMessage, ApplicationSettings.DispatchQueueName, keyVaultConnectionInfo);
                }
            }
            catch (Exception ex)
            {
                response.IsSucceded = false;

                if (ex is BusinessException)
                {
                    response.ResultId = ((BusinessException)ex).ResultId;
                }
                else
                {
                    response.ResultId = (int)DispatchResponseEnum.Failed;

                    this.logger.LogError($">> Exception: {ex.Message}, StackTrace: {ex.StackTrace}");

                    if (ex.InnerException != null)
                    {
                        this.logger.LogError($">> Inner Exception Message: {ex.InnerException.Message}, Inner Exception StackTrace: {ex.InnerException.StackTrace}");
                    }
                }
            }
            finally
            {
                keyVaultConnectionInfo = null;

                GC.Collect();
            }

            string message = EnumDescription.GetEnumDescription((DispatchResponseEnum)response.ResultId);
            this.logger.LogInformation($">> Message information: {message}");

            return (response.IsSucceded) ? (ActionResult)new OkObjectResult(new { message = message }) : (ActionResult)new BadRequestObjectResult(new { message = message });
        }
    }
}