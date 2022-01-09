using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using static Jks.GameServers.Shared.Contracts.Enums;

namespace Jks.GameServers.ServerOperator
{
    public interface IGameServer
    {
        public Task<GameServerOperationResult> BackupAsync();
        public Task<Tuple<GameServerOperationResult, IEnumerable<PlayerInfo>>> GetPlayersAsync();
        public Task<GameServerOperationResult> SaveAsync();
        public Task<Tuple<GameServerOperationResult, bool>> StartAsync();
        public Task<GameServerOperationResult> StopAsync();
        public Task EnsureStartedAsync();
    }
}
