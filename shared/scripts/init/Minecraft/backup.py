import datetime
import getopt
import glob
import json
import os
import shutil
from subprocess import call
import sys

untracked_items=["server.jar"]

def backup_saves_and_configs(shared_mount_location, backup_storage_name):
    path_to_saved = "{}/Minecraft".format(shared_mount_location)
    backup_version = datetime.datetime.now().strftime('%Y-%m-%d_%H%M')
    backup_directory_name = "Backup_{}".format(backup_version)
    backup_dir = "{}/{}".format(shared_mount_location, backup_directory_name)
    os.mkdir(backup_dir)
    try:
        for item in os.listdir(path_to_saved):
            if (item not in untracked_items):
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
    long_options = ["shared-mount-location=", "backup-storage-name="]

    shared_mount_location = None
    backup_storage_name = None

    try:
        # Parsing argument
        arguments, values = getopt.getopt(argumentList, options, long_options)
        
        # checking each argument
        for currentArgument, currentValue in arguments:

            if currentArgument == "--shared-mount-location":
                shared_mount_location = currentValue

            elif currentArgument == "--backup-storage-name":
                backup_storage_name = currentValue
                
    except getopt.error as err:
        # output error, and return with an error code
        print (str(err))

    if (shared_mount_location is None) or (backup_storage_name is None):
        sys.exit("Either --shared-mount-location or --backup-storage-name were not provided.")

    backup_saves_and_configs(shared_mount_location, backup_storage_name)