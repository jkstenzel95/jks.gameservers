namespace Jks.GameServers.Shared
{
    using System;
    using System.Threading.Tasks;
    using Microsoft.AspNetCore.Http;
    using Microsoft.AspNetCore.Http.Features;
    using Microsoft.AspNetCore.Server.Kestrel.Core;
    using Microsoft.Extensions.Logging;

    public sealed class HandleExceptionMiddleware : IMiddleware
    {
        private static readonly EventId ExEventId = new EventId(0, typeof(HandleExceptionMiddleware).FullName);

        private readonly ILogger<HandleExceptionMiddleware> _logger;

        public HandleExceptionMiddleware(ILogger<HandleExceptionMiddleware> logger)
        {
            _logger = logger;
        }

        public async Task InvokeAsync(HttpContext httpContext, RequestDelegate next)
        {
            try
            {
                await next(httpContext);
            }
            catch (Exception exception)
            {
                var wasExceptionHandled = false;
                var feature = httpContext.Features.Get<IResourceHandlerHandleExceptionFeature>();

                if (feature != null)
                {
                    wasExceptionHandled = await feature.TryHandleExceptionAsync(httpContext, exception);
                }

                _logger.Log(LogLevel.Error, ExEventId, new { wasExceptionHandled, hasStarted = httpContext.Response.HasStarted }, exception, DefaultLogFormatter.Default);

                if (!wasExceptionHandled && !httpContext.Response.HasStarted)
                {
                    // this is the exception kestrel throws when the http body length is too large and you try to read past the limit
                    if (exception is BadHttpRequestException)
                    {
                        await httpContext.Response.SetAsync(StatusCodes.Status413PayloadTooLarge);
                    }
                    else if (httpContext.Response.StatusCode < StatusCodes.Status400BadRequest)
                    {
                        await httpContext.Response.SetAsync(StatusCodes.Status500InternalServerError);
                    }
                }
            }
        }
    }

    public interface IResourceHandlerHandleExceptionFeature
    {
        Task<bool> TryHandleExceptionAsync(HttpContext httpContext, Exception ex);
    }

    public static partial class IFeatureCollectionExtensions
    {
        public static IFeatureCollection AddHandleException(this IFeatureCollection fc, Func<HttpContext, Exception, Task<bool>> tryHandleExceptionAsync)
        {
            fc.Set<IResourceHandlerHandleExceptionFeature>(new AddHandleExceptionFeature { TryHandleExceptionAsync = tryHandleExceptionAsync });
            return fc;
        }

        private class AddHandleExceptionFeature : IResourceHandlerHandleExceptionFeature
        {
            public Func<HttpContext, Exception, Task<bool>> TryHandleExceptionAsync { get; set; }

            Task<bool> IResourceHandlerHandleExceptionFeature.TryHandleExceptionAsync(HttpContext httpContext, Exception ex) => TryHandleExceptionAsync(httpContext, ex);
        }
    }
}