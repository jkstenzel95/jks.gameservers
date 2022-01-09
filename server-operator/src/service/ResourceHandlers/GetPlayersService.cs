using Grpc.Core;
using Jks.GameServers.ServerOperator.ActionManagers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Jks.GameServers.ServerOperator
{
    public class GetPlayersService : GetPlayers.GetPlayersBase
    {
        private IGameServer _gameServer;

        public GetPlayersService(
            IGameServer gameServer)
            : base()
        {
            _gameServer = gameServer;
        }

        public override Task<GetPlayersReply> GetPlayers(GetPlayersRequest request, ServerCallContext context)
        {
            return base.GetPlayers(request, context);
        }
    }
}
