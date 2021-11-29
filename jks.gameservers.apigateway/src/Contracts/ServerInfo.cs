using Newtonsoft.Json;
using System.Collections.Generic;

namespace Jks.GameServers.ApiGateway.Contracts
{
    public class ServerInfo
    {
        [JsonConstructor]
        public ServerInfo(string serverName, IReadOnlyList<MapInfo> maps)
        {
            ServerName = serverName;
            Maps = maps;
        }

        [JsonProperty(PropertyName = "serverName")]
        public string ServerName { get; }

        [JsonProperty(PropertyName = "maps")]
        public IReadOnlyList<MapInfo> Maps { get; }
    }
}