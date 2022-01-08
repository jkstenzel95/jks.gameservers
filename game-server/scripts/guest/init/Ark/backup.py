import datetime
import getopt
import json
import os
import shutil
from subprocess import call
import sys

nonsave_folders=["Config", "Logs", "SaveGames", "clusters"]

def backup_saves_and_configs(shared_mount_location, backup_storage_name):
    map_codes = {}
    mappings_file = "/game-info/ark_mappings.json"
    with open(os.path.expanduser(mappings_file)) as md:
        mappings_json = json.load(md)
        for idx, map_info in enumerate(mappings_json["maps"]):
            map_codes[map_info["name"]] = map_info["map_code"]
    path_to_saved = "{}/Ark/ShooterGame/Saved".format(shared_mount_location)
    backup_version = datetime.datetime.now().strftime('%Y-%m-%d_%H%M')
    backup_directory_name = "Backup_{}".format(backup_version)
    backup_dir = "{}/{}".format(shared_mount_location, backup_directory_name)
    os.mkdir(backup_dir)
    try:
        for dir_name in os.listdir(path_to_saved):
            full_folder_path = os.path.join(path_to_saved, dir_name)
            if (not os.path.isfile(full_folder_path)) and (dir_name not in nonsave_folders):
                os.mkdir("{}/{}".format(backup_dir, dir_name))
                shutil.copyfile("{}/{}.ark".format(full_folder_path, map_codes[dir_name]), "{}/{}/{}.ark".format(backup_dir, dir_name, map_codes[dir_name]))
    # copy SaveGames, clusters
    shutil.copytree("{}/clusters".format(path_to_saved), "{}/clusters".format(backup_dir))
    shutil.copytree("{}/SaveGames".format(path_to_saved), "{}/SaveGames".format(backup_dir))
    shutil.make_archive("{}/{}".format(shared_mount_location, backup_directory_name), "zip", backup_dir)
    backup_zip = "{}.zip".format(backup_directory_name)
    call(["aws", "s3", "cp", "{}/{}".format(shared_mount_location, backup_zip), "s3://{}/{}".format(backup_storage_name, backup_zip)])
    os.remove("{}/{}".format(shared_mount_location, backup_zip))
    finally:
        shutil.rmtree(backup_dir)

if __name__ == '__main__':
    # test1.py executed as script
    # do something

    # Remove 1st argument from the
    # list of command line arguments
    argumentList = sys.argv[1:]
    
    # Options
    options = ""
    
    # Long options
    long_options = ["server-mount-location=", "backup-storage-name="]

    shared_mount_location = None
    backup_storage_name = None

    try:
        # Parsing argument
        arguments, values = getopt.getopt(argumentList, options, long_options)
        
        # checking each argument
        for currentArgument, currentValue in arguments:

            if currentArgument == "--server-mount-location":
                shared_mount_location = currentValue

            elif currentArgument == "--backup-storage-name":
                backup_storage_name = currentValue
                
    except getopt.error as err:
        # output error, and return with an error code
        print (str(err))

    if (shared_files_location is None) or (env is None):
        sys.exit("Either --server-mount-location or --backup-storage-name were not provided.")

    backup_saves_and_configs(shared_mount_location, backup_storage_name)