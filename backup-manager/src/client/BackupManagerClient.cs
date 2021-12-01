using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace Jks.GameServers.BackupManager
{
    public class BackupManagerClient : IBackupManagerClient
    {
        public Task<BackupInfo> GetBackupAsync(string backupName, string serverName, string mapName = "default")
        {
            throw new NotImplementedException();
        }

        public Task<Uri> GetBackupDownloadUriAsync(string backupName, string serverName, string mapName = "default")
        {
            throw new NotImplementedException();
        }

        public Task<IReadOnlyList<BackupInfo>> GetBackupsAsync(string serverName, string mapName = "default")
        {
            throw new NotImplementedException();
        }
    }
}
