using Newtonsoft.Json;
using System;

namespace Jks.GameServers.ApiGateway.Contracts
{
    public class MapInfo
    {
        [JsonConstructor]
        public MapInfo(string mapName, Uri url)
        {
            MapName = mapName;
            Url = url;
        }

        [JsonProperty(PropertyName = "mapName")]
        public string MapName { get; }

        [JsonProperty(PropertyName = "url")]
        public Uri Url { get; }
    }
}
