using Jks.GameServers.Shared;
using System.Threading.Tasks;

namespace Jks.GameServers.ServerOperator
{
    interface IServerOperatorClient
    {
        public Task BackupServerAsync();
        public Task RestoreBackupAsync(string backupName, string serverName, string mapName = Constants.DefaultMapName);
        public Task SaveServerAsync();
        public Task StartServerAsync();
        public Task StopServerAsync();
    }
}
