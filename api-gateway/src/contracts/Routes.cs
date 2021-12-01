namespace Jks.GameServers.ApiGateway.Contracts
{
    public static class Routes
    {
        public const string Servers = "servers";
        public const string ServersFormatString = "servers";

        public const string Maps = "servers/{serverName}/maps";
        public const string MapsFormatString = "servers/{0}/maps";

        public const string Map = "servers/{serverName}/maps/{mapName}";
        public const string MapFormatString = "servers/{0}/maps/{1}";

        public const string Backups = "servers/{serverName}/maps/{mapName}/backups";
        public const string BackupsFormatString = "servers/{0}/maps/{1}/backups";

        public const string Backup = "servers/{serverName}/maps/{mapName}/backups/{backupName}";
        public const string BackupFormatString = "servers/{0}/maps/{1}/backups/{2}";

        public const string BackupMap = "servers/{serverName}/maps/{mapName}/startbackup";
        public const string BackupMapFormatString = "servers/{0}/maps/{1}/startbackup";

        public const string BackupRestore = "servers/{serverName}/maps/{mapName}/backups/{backupName}/restore";
        public const string BackupRestoreFormatString = "servers/{0}/maps/{1}/backups/{2}/restore";

        public const string BackupDownloadUri = "servers/{serverName}/maps/{mapName}/backups/{backupName}/downloaduri";
        public const string BackupDownloadUriFormatString = "servers/{0}/maps/{1}/backups/{2}/downloaduri";

        public const string StopMap = "servers/{serverName}/maps/{mapName}/Stop";
        public const string StopMapString = "servers/{0}/maps/{1}/Stop";

        public const string StartMap = "servers/{serverName}/maps/{mapName}/Start";
        public const string StartMapString = "servers/{0}/maps/{1}/Start";

        public const string Players = "servers/{serverName}/maps/{mapName}/players";
        public const string PlayersFormatString = "servers/{0}/maps/{1}/players";

        public const string PlayersCount = "servers/{serverName}/maps/{mapName}/players/count";
        public const string PlayersCountFormatString = "servers/{0}/maps/{1}/players/count";
    }

    public static class RouteConstants
    {
        public const string MapName = "mapName";
        public const string ServerName = "serverName";
    }
}
