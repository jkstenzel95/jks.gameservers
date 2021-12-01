using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace Jks.GameServers.Shared.Extensions
{
    public static class IConfigurationBuilderExtensions
    {
        public static IConfigurationBuilder AddJksConfigurationFile(this IConfigurationBuilder configurationBuilder)
        {
            var configFileName = Environment.GetEnvironmentVariable("SERVICE_CONFIG");
            var configFilePath = Path.Combine(Environment.CurrentDirectory, "config", configFileName);

            return configurationBuilder.AddJsonFile(configFilePath);
        }
    }
}
