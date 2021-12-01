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
    [Route(Routes.StopMap)]
    public class StopMapHandler : ApiGatewayHandlerBase
    {
        private readonly ILogger<StopMapHandler> _logger;

        public StopMapHandler(IHttpContextAccessor accessor, ILogger<StopMapHandler> logger)
            : base(accessor)
        {
            _logger = logger;
        }

        // Stops a map server
        [HttpGet]
        public async Task GetAsync(string gameName)
        {
            await Accessor.HttpContext.Response.SetAsync(HttpStatusCode.NotImplemented, SharedErrorCodes.NotImplemented, ClientFacingErrorMessages.NotImplemented);
        }
    }
}
