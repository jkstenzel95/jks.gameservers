using Jks.GameServers.Shared;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace Jks.GameServers.BackupManager
{
    public interface IBackupManagerClient
    {
        public Task<BackupInfo> GetBackupAsync(string backupName, string serverName, string mapName = Constants.DefaultMapName);
        public Task<IReadOnlyList<BackupInfo>> GetBackupsAsync(string serverName, string mapName = Constants.DefaultMapName);
        public Task<Uri> GetBackupDownloadUriAsync(string backupName, string serverName, string mapName = Constants.DefaultMapName);
    }
}
