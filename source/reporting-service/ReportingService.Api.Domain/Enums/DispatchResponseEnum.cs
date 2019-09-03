using System.ComponentModel;

namespace ReportingService.Api.Domain.Enums
{
    public enum DispatchResponseEnum
    {
        [Description("Request dispatched successfully, please wait the report by email.")]
        Success,

        [Description("Fullname can not be empty.")]
        FailedEmptyFullname,

        [Description("Email can not be empty.")]
        FailedEmptyEmail,

        [Description("There was a problem in the dispatch process.")]
        Failed
    }
}