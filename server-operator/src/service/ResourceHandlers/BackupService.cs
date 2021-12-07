using Grpc.Core;
using Jks.GameServers.ServerOperator.ActionManagers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Jks.GameServers.ServerOperator
{
    public class BackupService : Backup.BackupBase
    {
        private IGameServer _gameServer;

        public BackupService(
            IGameServer gameServer)
            : base()
        {
            _gameServer = gameServer;
        }

        public override Task<BackupReply> Backup(BackupRequest request, ServerCallContext context)
        {
            return base.Backup(request, context);
        }
    }
}
