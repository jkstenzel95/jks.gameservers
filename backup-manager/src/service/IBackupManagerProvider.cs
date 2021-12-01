using Jks.GameServers.BackupManager;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Jks.GameServers.BackupService
{
    interface IBackupManagerProvider
    {
        IBackupManager GetBackupManager();
    }
}
