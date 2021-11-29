using Jks.GameServers.ApiGateway.Contracts;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Jks.GameServers.ApiGateway.ResourceHandlers
{
    public abstract class ApiGatewayHandlerBase
    {
        public ApiGatewayHandlerBase(IHttpContextAccessor accessor)
        {
            Accessor = accessor;
        }

        protected IHttpContextAccessor Accessor { get; }

        protected static bool TryGetMapNameFromRoute(HttpContext context, out string serverName)
        {
            object routeElementValue = context.GetRouteValue(RouteConstants.ServerName);
            serverName = routeElementValue as string ?? string.Empty;
            return string.IsNullOrWhiteSpace(serverName);
        }

        protected static bool TryGetServerNameFromRoute(HttpContext context, out string serverName)
        {
            object routeElementValue = context.GetRouteValue(RouteConstants.ServerName);
            serverName = routeElementValue as string ?? string.Empty;
            return string.IsNullOrWhiteSpace(serverName);
        }
    }
}
