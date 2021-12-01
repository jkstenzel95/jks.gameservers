// -----------------------------------------------------------------------
// <copyright file="HttpResponseExtensions.cs" company="Microsoft Corporation">
// Copyright (c) Microsoft Corporation. All rights reserved.
// </copyright>
// -----------------------------------------------------------------------

namespace Jks.GameServers.ApiGateway.Extensions
{
    using System.Net;
    using System.Threading.Tasks;
    using Jks.GameServers.ApiGateway.Contracts;
    using Jks.GameServers.Shared;
    using Jks.GameServers.Shared.Contracts;
    using Microsoft.AspNetCore.Http;

    public static class HttpResponseExtensions
    {
        public static async Task SetAsync(
            this HttpResponse response,
            HttpStatusCode statusCode,
            string errorCode,
            string errorMessage)
        {
            await response.SetAsync(statusCode, new ErrorResponse(errorCode, errorMessage));
        }

        public static async Task SetAsync(this HttpResponse response, ApiGatewayException ex)
        {
            await SetAsync(
                response,
                ex.StatusCode ?? HttpStatusCode.InternalServerError,
                ex.ErrorResponse.ErrorResponseInfo.Code,
                ex.ErrorResponse.ErrorResponseInfo.Message);
        }
    }
}
