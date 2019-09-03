using System.ComponentModel;

namespace ReportingService.Processor.Domain.Enums
{
    public enum DispatchResponseEnum
    {
        [Description("Request processed successfully, email has been sent.")]
        Success,

        [Description("There was a problem in the dispatch process.")]
        Failed
    }
}