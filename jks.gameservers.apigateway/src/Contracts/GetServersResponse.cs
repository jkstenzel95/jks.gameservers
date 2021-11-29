using System.Collections.Generic;
using Newtonsoft.Json;

namespace Jks.GameServers.ApiGateway.Contracts
{
    public class GetServersResponse
    {
        [JsonConstructor]
        public GetServersResponse(IReadOnlyList<ServerInfo> servers)
        {
            Servers = servers;
        }

        [JsonProperty(PropertyName = "servers")]
        public IReadOnlyList<ServerInfo> Servers { get; }
    }
}
