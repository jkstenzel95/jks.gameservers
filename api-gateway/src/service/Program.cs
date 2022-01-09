using Jks.GameServers.Shared.Extensions;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Jks.GameServers.ApiGateway
{
    public class Program
    {
        public async static void Main(string[] args)
        {
            try
            {
                IWebHostBuilder builder = new WebHostBuilder()
                    .ConfigureAppConfiguration((webHostBuilderContext, configurationBuilder) =>
                    {
                        configurationBuilder
                        .AddEnvironmentVariables()
                        .AddJksConfigurationFile();
                    })
                    .UseKestrel()
                    .UseStartup<Startup>();
                using (IWebHost server = builder.Build())
                {
                    await server.RunAsync();
                }
            }
        }

        private static void UnhandledException(object sender, UnhandledExceptionEventArgs args)
        {
            var exception = args.ExceptionObject as Exception;
            Console.WriteLine("Unhandled exception.\n Exception: {0}", exception?.ToString() ?? "Exception is null");
        }
    }
}
