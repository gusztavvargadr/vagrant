using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace WebApplication.Controllers
{
    public class HomeController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        public IActionResult About()
        {
            ViewData["Message"] = "Your application description page.";

            return View();
        }

        public IActionResult Contact()
        {
            ViewData["Message"] = "Your contact page.";

            return View();
        }

        public IActionResult Error()
        {
            return View();
        }

        public static string GetHomeDirectory() {
          var homePath = Environment.GetEnvironmentVariable("HOMEPATH");
          if (!string.IsNullOrEmpty(homePath)) {
            return homePath;
          }

          var home = Environment.GetEnvironmentVariable("HOME");
          return home;
        }
    }
}
