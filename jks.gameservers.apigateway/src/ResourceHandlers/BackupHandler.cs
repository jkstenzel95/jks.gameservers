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
    [Route(Routes.BackupMap)]
    public class BackupMapHandler : ApiGatewayHandlerBase
    {
        private readonly ILogger<BackupMapHandler> _logger;

        public BackupMapHandler(IHttpContextAccessor accessor, ILogger<BackupMapHandler> logger)
            : base(accessor)
        {
            _logger = logger;
        }

        // Gets a details for a specific map backup
        [HttpGet]
        public async Task GetAsync(string backupName, string gameName, string mapName = Constants.DefaultMapName)
        {
            await Accessor.HttpContext.Response.SetAsync(HttpStatusCode.NotImplemented, SharedErrorCodes.NotImplemented, ClientFacingErrorMessages.NotImplemented);
        }
    }
}
