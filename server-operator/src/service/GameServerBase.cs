using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using static Jks.GameServers.Shared.Contracts.Enums;

namespace Jks.GameServers.ServerOperator
{
    public abstract class GameServerBase : IGameServer
    {
        public async Task<GameServerOperationResult> BackupAsync()
        {
            if (!await IsRunningAsync())
            {
                if (!await StartService())
            }
        }

        public async Task EnsureStartedAsync()
        {
            if (!await IsRunningAsync())
            {
                 
            }
        }

        public Task GetPlayersAsync()
        {
            throw new NotImplementedException();
        }

        

        public Task<GameServerOperationResult> SaveAsync()
        {
            throw new NotImplementedException();
        }

        public Task<Tuple<GameServerOperationResult, bool>> StartAsync()
        {
            throw new NotImplementedException();
        }

        public Task<GameServerOperationResult> StopAsync()
        {
            throw new NotImplementedException();
        }

        public abstract Task<GameServerOperationResult> BackupImplAsync();

        public abstract Task EnsureStartedImplAsync();

        public abstract Task<Tuple<GameServerOperationResult, IEnumerable<PlayerInfo>>> GetPlayersImplAsync();

        public abstract Task<GameServerOperationResult> SaveImplAsync();

        public abstract Task<Tuple<GameServerOperationResult, bool>> StartImplAsync();

        public abstract Task<GameServerOperationResult> StopImplAsync();

        private Task<bool> IsRunningAsync()
        {
            int? pid = await GetPidAsync();
        }

        private Task<int?> GetPidAsync()
        {
            if ()
        }
    }
}
