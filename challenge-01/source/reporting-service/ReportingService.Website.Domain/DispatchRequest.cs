using System.ComponentModel.DataAnnotations;

namespace ReportingService.Website.Domain
{
    public class DispatchRequest
    {
        [Display(Name = "Full name")]
        [Required]
        [StringLength(150, ErrorMessage = "Full name length can't be more than 150.")]
        public string Fullname { get; set; }

        [Display(Name = "Email")]
        [RegularExpression(@"\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*", ErrorMessage = "Email must be a valid email address."), Required, StringLength(50)]
        public string Email { get; set; }
    }
}