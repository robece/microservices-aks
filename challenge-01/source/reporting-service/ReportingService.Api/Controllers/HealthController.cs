using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Threading.Tasks;

// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace ReportingService.Api.Controllers
{
    [Route("api/[controller]")]
    public class HealthController : Controller
    {
        private readonly ILogger logger = null;

        public HealthController(ILogger<DispatchController> logger)
        {
            this.logger = logger;
        }

        [HttpGet]
        public async Task<IActionResult> Get()
        {
            return (ActionResult)new OkObjectResult(new { message = "Up and running!!" });
        }
    }
}