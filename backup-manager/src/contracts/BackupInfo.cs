using Newtonsoft.Json;
using System.Collections.Generic;

namespace Jks.GameServers.BackupManager
{
    public class BackupInfo
    {
        [JsonConstructor]
        public BackupInfo(IReadOnlyList<BackupInfo> backups)
        {
            Backups = backups;
        }

        [JsonProperty(PropertyName = "backups")]
        public IReadOnlyList<BackupInfo> Backups { get; }
    }
}
