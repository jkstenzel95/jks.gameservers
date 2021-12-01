using Jks.GameServers.BackupManager;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Jks.GameServers.ServerOperator
{
    public interface IServerOperator
    {
        public BackupInfo BackupServer();
        public int GetPlayerCount();
        public void SaveServer();
        public void StartServer();
        public void StopServer();
        
    }
}
