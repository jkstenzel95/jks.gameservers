using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace Jks.GameServers.Shared
{
    public static class IServiceCollectionExtensions
    {
        public static IServiceCollection AddJksLogging(this IServiceCollection services, IConfiguration configuration)
        {
            services.AddLogging(config =>
            {
                config.AddAWSProvider(configuration.GetAWSLoggingConfigSection());
                config.SetMinimumLevel(LogLevel.Debug);
            });

            return services;
        }
    }
}
