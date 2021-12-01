using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace Jks.GameServers.ServerOperator
{
    public class ServerManagementClient : IServerOperatorClient
    {
        public Task BackupServerAsync()
        {
            throw new NotImplementedException();
        }

        public Task RestoreBackupAsync(string backupName, string serverName, string mapName = "default")
        {
            throw new NotImplementedException();
        }

        public Task SaveServerAsync()
        {
            throw new NotImplementedException();
        }

        public Task StartServerAsync()
        {
            throw new NotImplementedException();
        }

        public Task StopServerAsync()
        {
            throw new NotImplementedException();
        }
    }
}
