using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ConsoleApplication
{
    public class Program
    {
        public static void Main(string[] args)
        {
            Console.WriteLine(string.Format("Hello World from {0}", GetHomeDirectory()));
        }

        private static string GetHomeDirectory() {
          var homePath = Environment.GetEnvironmentVariable("HOMEPATH");
          if (!string.IsNullOrEmpty(homePath)) {
            return homePath;
          }

          var home = Environment.GetEnvironmentVariable("HOME");
          return home;
        }
    }
}
