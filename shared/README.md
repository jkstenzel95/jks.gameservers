# shared
The data and logic shared across deployment pipelines and server/node setup/startup

### config
- Descriptions of the states of various environments

### data
- The mappings associated with games

### scripts
- Scripts for setting up and running game servers

## Notes:
- To set a backup for restore, in the backup table, add the following:
    - Key: jks-gs-{ENV}-{REGION_SHORTNAME}-{GAME_NAME}-{MAP_NAME}-kv_table
        - Capitalization matters - if the game is 'Ark', use that instead of 'ark'
    - KeyValue: {BACKUP_VERSION}
        - Backup version is the name of the zip file minus the ".zip"