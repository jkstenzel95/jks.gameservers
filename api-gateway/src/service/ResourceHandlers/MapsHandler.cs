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
    [Route(Routes.Maps)]
    public class MapsHandler : ApiGatewayHandlerBase
    {
        private readonly ILogger<MapsHandler> _logger;

        public MapsHandler(IHttpContextAccessor accessor, ILogger<MapsHandler> logger)
            : base(accessor)
        {
            _logger = logger;
        }

        // Gets a list of maps for a game
        [HttpGet]
        public async Task GetAsync(string gameName)
        {
            await Accessor.HttpContext.Response.SetAsync(HttpStatusCode.NotImplemented, SharedErrorCodes.NotImplemented, ClientFacingErrorMessages.NotImplemented);
        }
    }
}
