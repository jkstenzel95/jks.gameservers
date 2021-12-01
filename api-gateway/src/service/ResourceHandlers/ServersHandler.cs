using Jks.GameServers.ApiGateway.Contracts;
using Jks.GameServers.ApiGateway.Extensions;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System.Net;
using System.Threading.Tasks;

using SharedErrorCodes = Jks.GameServers.Shared.Contracts.ErrorCodes;

namespace Jks.GameServers.ApiGateway.ResourceHandlers
{
    [ApiController]
    [Route(Routes.Servers)]
    public class ServersHandler : ApiGatewayHandlerBase
    {
        private readonly ILogger<ServersHandler> _logger;

        public ServersHandler(IHttpContextAccessor accessor, ILogger<ServersHandler> logger)
            : base(accessor)
        {
            _logger = logger;
        }

        // Gets a list of available game servers
        [HttpGet]
        public async Task GetAsync()
        {
            await Accessor.HttpContext.Response.SetAsync(HttpStatusCode.NotImplemented, SharedErrorCodes.NotImplemented, ClientFacingErrorMessages.NotImplemented);
        }
    }
}
