using Newtonsoft.Json;

namespace Jks.GameServers.Shared.Contracts
{
    public class ErrorResponse
    {
        public ErrorResponse(string code, string message)
        {
            ErrorResponseInfo = new ErrorResponseInfo
            {
                Code = code,
                Message = message
            };
        }

        [JsonProperty(PropertyName = "error")]
        public ErrorResponseInfo ErrorResponseInfo { get; set; } = new ErrorResponseInfo();
    }
}
