using ReportingService.Processor.Helpers.Base;
using SendGrid.Helpers.Mail;
using System;
using System.Threading.Tasks;

namespace ReportingService.Processor.Helpers
{
    public class SendGridHelper : BaseHelper
    {
        public async Task SendReportEmailAsync(
            string emailTo, string emailToFullname, string pdf)
        {
            //configure sendergrid api.
            string apiKey = ApplicationSettings.SendGridAPIKey;
            var client = new SendGrid.SendGridClient(apiKey);

            //build mail.
            var from = new EmailAddress("robece@reportingservice.com.mx", "Reporting Service");
            var to = new EmailAddress($"{emailTo}", $"{emailToFullname}");
            string subject = "Reporting Service Notification: Report completed";

            var plainTextContent = string.Empty;

            var htmlContent =
                $"Hello {emailToFullname}!" +
                $"<br/><br/>" +
                $"We have successfully generated the requested report, please see the attachments." +
                $"<br/><br/>" +
                $"Thanks for using Reporting Service," +
                $"<br/>" +
                $"Reporting Service team";

            var msg = SendGrid.Helpers.Mail.MailHelper.CreateSingleEmail(from, to, subject, plainTextContent, htmlContent);
            msg.AddAttachment(new Attachment() { Type = "application/pdf", Content = pdf, Filename = "Report.pdf", ContentId = Guid.NewGuid().ToString(), Disposition = "attachment" });
            var response = await client.SendEmailAsync(msg);
        }
    }
}