using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using ReportingService.Website.Domain;
using ReportingService.Website.Models;
using System.Diagnostics;
using System.Net.Http;
using System.Threading.Tasks;

namespace ReportingService.Website.Controllers
{
    public class HomeController : Controller
    {
        private readonly IHttpClientFactory httpClientFactory;

        public HomeController(IHttpClientFactory httpClientFactory)
        {
            this.httpClientFactory = httpClientFactory;
        }

        public IActionResult Index()
        {
            return View();
        }

        public IActionResult Thanks(string message)
        {
            if (string.IsNullOrEmpty(message))
            {
                TempData["message"] = "Oopps!! There was an error processing the request.";
            }
            else
            {
                dynamic json = JObject.Parse(message);
                TempData["message"] = json.message;
            }

            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Index(DispatchRequest model)
        {
            if (ModelState.IsValid)
            {
                string result = string.Empty;

                dynamic body = new JObject();
                body.Fullname = model.Fullname;
                body.Email = model.Email;
                StringContent queryString = new StringContent(body.ToString(), System.Text.Encoding.UTF8, "application/json");

                var client = httpClientFactory.CreateClient();
                var response = await client.PostAsync($"http://{ApplicationSettings.APIHostname}/api/dispatch", queryString);
                result = await response.Content.ReadAsStringAsync();

                return RedirectToAction("Thanks", new { message = result });
            }

            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}