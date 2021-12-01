using System.IO;
using System.Net;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.Features;
using Microsoft.IO;
using Newtonsoft.Json;

namespace Jks.GameServers.Shared
{
    public static class HttpResponseExtensions
    {
        // Size of each block that is pooled.
        private const int MemoryPoolBlockSize = 128 * 1024; // 128 KiB

        // Each large buffer will be a multiple of this value in bytes.
        private const int MemoryPoolBufferMultiple = 1024 * 1024; // 1 MiB

        // Buffers larger than this size are not pooled.
        private const int MemoryPoolMaximumBufferSize = 8 * 1024 * 1024; // 8 MiB

        // Maximum capacity in bytes, beyond which the memory stream will throw an exception.
        // Setting this to zero disables the limit.
        private const long MaximumStreamCapacity = MemoryPoolMaximumBufferSize;

        // Whether memory stream buffers should be re-used immediately after a re-allocation.
        // It is unsafe to hold onto buffers returned by MemoryStream.GetBuffer() past further
        // writes to the stream if this option is enabled.
        private const bool ReuseStreamBuffersImmediately = true;

        // Maximum size of the block pool in bytes, before blocks are returned to the runtime.
        // Setting this to zero disables the limit.
        private const long MaximumFreeSmallPoolBytes = 0;

        // Maximum size of the large buffer pool in bytes, before large buffers are returned to
        // the runtime.
        // Setting this to zero disables the limit.
        private const long MaximumFreeLargePoolBytes = 0;

        private const string ContentType = "application/json; charset=utf-8";

        private static readonly Encoding _encoding;

        private static readonly JsonSerializer _json;

        // The memory manager used for pooling HTTP response buffers
        private static readonly RecyclableMemoryStreamManager MemoryManager =
            new RecyclableMemoryStreamManager(
                MemoryPoolBlockSize,
                MemoryPoolBufferMultiple,
                MemoryPoolMaximumBufferSize)
            {
                MaximumStreamCapacity = MaximumStreamCapacity,
                AggressiveBufferReturn = ReuseStreamBuffersImmediately,
                MaximumFreeSmallPoolBytes = MaximumFreeSmallPoolBytes,
                MaximumFreeLargePoolBytes = MaximumFreeLargePoolBytes,
            };

        static HttpResponseExtensions()
        {
            _encoding = new UTF8Encoding(encoderShouldEmitUTF8Identifier: false);
            _json = new JsonSerializer
            {
                DateParseHandling = DateParseHandling.None,
                NullValueHandling = NullValueHandling.Include,
            };
        }

        public static async Task SetAsync(this HttpResponse response, int statusCode, object body = default, CancellationToken cancellation = default)
        {
            response.StatusCode = statusCode;

            if (statusCode >= StatusCodes.Status400BadRequest)
            {
                response.HttpContext.Features.Get<IHttpResponseFeature>().ReasonPhrase = body?.ToString();
            }

            if (body == null)
            {
                response.ContentLength = 0;
                response.Body = Stream.Null;
            }

            else
            {
                using var memory = new RecyclableMemoryStream(MemoryManager);
                using (var stream = new StreamWriter(memory, _encoding, bufferSize: 512, leaveOpen: true))
                using (var writer = new JsonTextWriter(stream))
                {
                    _json.Serialize(writer, body);
                }

                response.ContentLength = memory.Position;
                response.ContentType = ContentType;
                await response.Body.WriteAsync(memory.GetBuffer(), offset: 0, count: (int)memory.Position, cancellation);
            }
        }

        public static async Task SetAsync(this HttpResponse response, HttpStatusCode statusCode, object body = default, CancellationToken cancellation = default) => await SetAsync(response, (int)statusCode, body, cancellation);
    }
}
