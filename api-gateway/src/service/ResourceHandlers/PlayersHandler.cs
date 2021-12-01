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
    [Route(Routes.Players)]
    public class PlayersHandler : ApiGatewayHandlerBase
    {
        private readonly ILogger<PlayersHandler> _logger;

        public PlayersHandler(IHttpContextAccessor accessor, ILogger<PlayersHandler> logger)
            : base(accessor)
        {
            _logger = logger;
        }

        // Gets a list of players in-game on a map
        [HttpGet]
        public async Task GetAsync(string gameName, string mapName = Constants.DefaultMapName)
        {
            await Accessor.HttpContext.Response.SetAsync(HttpStatusCode.NotImplemented, SharedErrorCodes.NotImplemented, ClientFacingErrorMessages.NotImplemented);
        }
    }
}
