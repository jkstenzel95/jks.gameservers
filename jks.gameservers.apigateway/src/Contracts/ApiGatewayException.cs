using Jks.GameServers.Shared.Contracts;
using System;
using System.Net;

namespace Jks.GameServers.ApiGateway.Contracts
{
    public class ApiGatewayException : Exception
    {
        public ApiGatewayException(
            ErrorResponse errorResponse,
            HttpStatusCode statusCode,
            Exception? innerException)
            : base(
                  errorResponse.ErrorResponseInfo.Message,
                  innerException)
        {
            ErrorResponse = errorResponse;
            StatusCode = statusCode;
        }

        public ErrorResponse ErrorResponse { get; set; }

        public HttpStatusCode? StatusCode { get; }
    }
}
