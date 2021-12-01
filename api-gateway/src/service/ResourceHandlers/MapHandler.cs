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
    [Route(Routes.Map)]
    public class MapHandler : ApiGatewayHandlerBase
    {
        private readonly ILogger<MapHandler> _logger;

        public MapHandler(IHttpContextAccessor accessor, ILogger<MapHandler> logger)
            : base(accessor)
        {
            _logger = logger;
        }

        // Gets details for a map
        [HttpGet]
        public async Task GetAsync(string gameName, string mapName = Constants.DefaultMapName)
        {
            await Accessor.HttpContext.Response.SetAsync(HttpStatusCode.NotImplemented, SharedErrorCodes.NotImplemented, ClientFacingErrorMessages.NotImplemented);
        }
    }
}
