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
    [Route(Routes.Backups)]
    public class BackupsHandler : ApiGatewayHandlerBase
    {
        private readonly ILogger<BackupsHandler> _logger;

        public BackupsHandler(IHttpContextAccessor accessor, ILogger<BackupsHandler> logger)
            : base(accessor)
        {
            _logger = logger;
        }

        // Gets a list of backups for a map
        [HttpGet]
        public async Task GetAsync(string serverName, string mapName = Constants.DefaultMapName)
        {
            await Accessor.HttpContext.Response.SetAsync(HttpStatusCode.NotImplemented, SharedErrorCodes.NotImplemented, ClientFacingErrorMessages.NotImplemented);
        }

        // Starts a new backup for a map
        [HttpPost]
        public async Task PostAsync()
        {
            await Accessor.HttpContext.Response.SetAsync(HttpStatusCode.NotImplemented, SharedErrorCodes.NotImplemented, ClientFacingErrorMessages.NotImplemented);
        }
    }
}
