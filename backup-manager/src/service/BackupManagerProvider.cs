using Jks.GameServers.BackupManager;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Jks.GameServers.BackupService
{
    public class BackupManagerProvider : IBackupManagerProvider
    {
        public IBackupManager GetBackupManager()
        {
            throw new NotImplementedException();
        }
    }
}
