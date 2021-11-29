using Jks.GameServers.ApiGateway.Contracts;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Jks.GameServers.Shared.Contracts
{
    public class ErrorResponseInfo
    {
        [JsonProperty(PropertyName = "code", Required = Required.Always)]
        public string Code { get; set; } = ErrorCodes.Unknown;

        [JsonProperty(PropertyName = "message", Required = Required.Always)]
        public string Message { get; set; }
    }
}
