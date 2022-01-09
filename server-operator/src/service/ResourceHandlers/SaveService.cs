using Grpc.Core;
using Jks.GameServers.ServerOperator.ActionManagers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Jks.GameServers.ServerOperator
{
    public class SaveService : Save.SaveBase
    {
        private IGameServer _gameServer;

        public SaveService(
            IGameServer gameServer)
            : base()
        {
            _gameServer = gameServer;
        }

        public override Task<SaveReply> SaveServer(SaveRequest request, ServerCallContext context)
        {
            return base.Save(request, context);
        }
    }
}
