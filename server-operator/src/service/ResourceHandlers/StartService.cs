using Grpc.Core;
using Jks.GameServers.ServerOperator.ActionManagers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Jks.GameServers.ServerOperator
{
    public class StartService : Start.StartBase
    {
        private IGameServer _gameServer;

        public startService(
            IGameServer gameServer)
            : base()
        {
            _gameServer = gameServer;
        }

        public override Task<StartServerReply> StartServer(StartServerRequest request, ServerCallContext context)
        {
            return base.StartServer(request, context);
        }
    }
}
