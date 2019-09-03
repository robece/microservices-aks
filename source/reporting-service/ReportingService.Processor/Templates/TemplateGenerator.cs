using ReportingService.Processor.Domain.Entities.Queue;
using System.Text;

namespace ReportingService.Processor.Templates
{
    public static class TemplateGenerator
    {
        public static string GetHTMLString(DispatchMessage dispatchMessage)
        {
            var sb = new StringBuilder();
            sb.Append($@"
                        <html>
                            <head>
                            </head>
                            <body>
                                <div class='header'><h1>Reporting Service</h1></div>
                                <table align='center'>
                                    <tr>
                                        <th>Fullname</th>
                                        <th>Email</th>
                                    </tr>
                                    <tr>
                                        <td>{dispatchMessage.Fullname}</td>
                                        <td>{dispatchMessage.Email}</td>
                                    </tr>
                                </table>
                            </body>
                        </html>");

            return sb.ToString();
        }
    }
}