# shared
The data and logic shared across deployment pipelines and server/node setup/startup

## Directories
### config
- Descriptions of the states of various environments

### data
- The mappings associated with games

### scripts
- Scripts for setting up and running game servers

## Notes:
- To set a backup for restore, in the backup table, add the following:
    - Key: backup_version
    - KeyValue: {BACKUP_VERSION}
        - Backup version is the name of the zip file minus the ".zip"
- Any changes to packages requires a publish, then a packages version bump in infra/service (see that README.md to understand how to do that), then an instance termination
    - This is because infra changes the launch template, but doesn't necessarily rerun the relevant launch scripts which download these packages