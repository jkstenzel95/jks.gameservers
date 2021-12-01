using Jks.GameServers.ApiGateway.Contracts;
using Jks.GameServers.ApiGateway.Extensions;
using Jks.GameServers.Shared;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System.Net;
using System.Threading.Tasks;

using SharedErrorCodes = Jks.GameServers.Shared.Contracts.ErrorCodes;

namespace Jks.GameServers.ApiGateway.ResourceHandlers
{
    [ApiController]
    [Route(Routes.StartMap)]
    public class StartMapHandler : ApiGatewayHandlerBase
    {
        private readonly ILogger<StartMapHandler> _logger;

        public StartMapHandler(IHttpContextAccessor accessor, ILogger<StartMapHandler> logger)
            : base(accessor)
        {
            _logger = logger;
        }

        // Starts a map sersver
        [HttpGet]
        public async Task GetAsync(string gameName)
        {
            await Accessor.HttpContext.Response.SetAsync(HttpStatusCode.NotImplemented, SharedErrorCodes.NotImplemented, ClientFacingErrorMessages.NotImplemented);
        }
    }
}
