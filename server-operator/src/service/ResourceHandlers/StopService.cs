using Grpc.Core;
using Jks.GameServers.ServerOperator.ActionManagers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Jks.GameServers.ServerOperator
{
    public class StopService : Stop.StopBase
    {
        private IStopServer _stopServer;

        public StopService(
            IStopServer stopServer)
            : base()
        {
            _stopServer = stopServer;
        }

        public override Task<StopServerReply> StopServer(StopServerRequest request, ServerCallContext context)
        {
            return base.StopServer(request, context);
        }
    }
}
