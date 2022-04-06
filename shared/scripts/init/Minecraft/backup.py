import datetime
import getopt
import glob
import json
import os
import re
import shutil
from subprocess import call
import sys

untracked_items=["server.jar", "mods", "libraries" ]
untracked_regexes=[ ".+\.jar", ".+\.so" ]

def backup_saves_and_configs(shared_mount_location, backup_storage_name, map_name):
    path_to_saved = "{}/Minecraft".format(shared_mount_location)
    backup_version = datetime.datetime.now().strftime('%Y-%m-%d_%H%M')
    backup_directory_name = "Backup_{}".format(backup_version)
    backup_dir = "{}/{}".format(shared_mount_location, backup_directory_name)
    mappings_file = "/gameservers-package/shared/data/minecraft_mappings.json"
    os.mkdir(backup_dir)
    is_modded = False
    with open(os.path.expanduser(mappings_file)) as md:
        mappings_json = json.load(md)
        for idx, map_info in enumerate(mappings_json["maps"]):
            if map_info["name"] == :
    try:
        for item in os.listdir(path_to_saved):
            if (item not in untracked_items):
                matched = False
                for pattern in untracked_regexes:
                    if bool(re.match(pattern, item)):
                        matched = True
                        break
                if matched:
                    continue
                full_item_path = os.path.join(path_to_saved, item)
                if (os.path.isfile(full_item_path)):
                    shutil.copy(full_item_path, "{}/{}".format(backup_dir, item))
                else:
                    shutil.copytree(full_item_path, "{}/{}".format(backup_dir, item))
        shutil.make_archive("{}/{}".format(shared_mount_location, backup_directory_name), "zip", backup_dir)
        backup_zip = "{}.zip".format(backup_directory_name)
        call(["aws", "s3", "cp", "{}/{}".format(shared_mount_location, backup_zip), "s3://{}/{}".format(backup_storage_name, backup_zip)])
        os.remove("{}/{}".format(shared_mount_location, backup_zip))
    finally:
        shutil.rmtree(backup_dir)

if __name__ == '__main__':
    argumentList = sys.argv[1:]
    
    # Options
    options = ""
    
    # Long options
    long_options = ["shared-mount-location=", "backup-storage-name=", "map-name="]

    shared_mount_location = None
    backup_storage_name = None
    map_name = None

    try:
        # Parsing argument
        arguments, values = getopt.getopt(argumentList, options, long_options)
        
        # checking each argument
        for currentArgument, currentValue in arguments:

            if currentArgument == "--shared-mount-location":
                shared_mount_location = currentValue

            elif currentArgument == "--backup-storage-name":
                backup_storage_name = currentValue

            elif currentArgument == "--map-name":
                map_name = currentValue
                
    except getopt.error as err:
        # output error, and return with an error code
        print (str(err))

    if (shared_mount_location is None) or (backup_storage_name is None) or (map_name is None):
        sys.exit("Either --shared-mount-location, --backup-storage-name, or --map-name were not provided.")

    backup_saves_and_configs(shared_mount_location, backup_storage_name, map_name)