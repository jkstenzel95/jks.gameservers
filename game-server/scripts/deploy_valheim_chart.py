import getopt
import json
import os
import sys
import deployment_utilities
from subprocess import call

def apply_charts(mappings_file, config_file, env, region, test):
    ports = []
    dir_path = os.path.dirname(os.path.realpath(__file__))
    call_command = ["{}/helm_deploy_serviceaccount.sh".format(dir_path), "-g", "Valheim", "-e", env]
    if test:
        call_command.append("-t")
    call(call_command)

    with open(mappings_file) as md:
        with open(config_file) as cd:
            mappings_json = json.load(md)
            config_json = json.load(cd)
            
            for game in config_json["games"]:
                if game["name"] == "Valheim":
                    map_set = set(game["maps"])
                    image_version = game["image_version"]
                    for idx, map_info in enumerate(mappings_json["maps"]):
                        map = map_info["name"]
                        if map in map_set:
                            print("Creating cluster for map {}; Image tag {}".format(map, image_version))
                            game_port = deployment_utilities.get_port_number(2456, idx, 3)
                            print("We're looking at game port {}".format(game_port))
                            gp1_port_string = "ports[0].name=SERVER_PORT,ports[0].protocol=TCP,ports[0].number={},ports[0].game=Valheim,ports[0].map={}".format(game_port, map)
                            gp2_port_string = "ports[1].name=SERVER_PORT_2,ports[1].protocol=TCP,ports[1].number={},ports[1].game=Valheim,ports[1].map={}".format(game_port + 1, map)
                            gp3_port_string = "ports[2].name=SERVER_PORT_3,ports[2].protocol=TCP,ports[2].number={},ports[2].game=Valheim,ports[2].map={}".format(game_port + 2, map)
                            gp1_udp_port_string = "ports[3].name=SERVERPORT_UDP,ports[3].protocol=UDP,ports[3].number={},ports[3].game=Valheim,ports[3].map={}".format(game_port, map)
                            gp2_udp_port_string = "ports[4].name=SERVERPORT2_UDP,ports[4].protocol=UDP,ports[4].number={},ports[4].game=Valheim,ports[4].map={}".format(game_port + 1, map)
                            gp3_udp_port_string = "ports[5].name=SERVERPORT3_UDP,ports[5].protocol=UDP,ports[5].number={},ports[5].game=Valheim,ports[5].map={}".format(game_port + 2, map)
                            port_name_prefix = "VALHEIM_{}_{}".format(map.upper(), env.upper())
                            ports.append({ "name": "{}_SERVER_PORT".format(port_name_prefix), "protocol": "TCP", "number": game_port, "game": "Valheim", "map": map })
                            ports.append({ "name": "{}_SERVER_PORT_2".format(port_name_prefix), "protocol": "TCP", "number": game_port + 1, "game": "Valheim", "map": map })
                            ports.append({ "name": "{}_SERVER_PORT_3".format(port_name_prefix), "protocol": "TCP", "number": game_port + 2, "game": "Valheim", "map": map })
                            ports.append({ "name": "{}_SERVERPORT_UDP".format(port_name_prefix), "protocol": "UDP", "number": game_port, "game": "Valheim", "map": map })
                            ports.append({ "name": "{}_SERVERPORT2_UDP".format(port_name_prefix), "protocol": "UDP", "number": game_port + 1, "game": "Valheim", "map": map })
                            ports.append({ "name": "{}_SERVERPORT3_UDP".format(port_name_prefix), "protocol": "UDP", "number": game_port + 2, "game": "Valheim", "map": map })
                            env_file = "{}_env_list.txt".format(map)
                            env_file_path = "{}/../helm/game-server/{}".format(dir_path, env_file)
                            # No justification for a additional env variables yet/anymore. Here as a guideline to show how it's done, but has no effect on the deployment
                            env_dict = {  }
                            deployment_utilities.generate_env_file(env_dict, env_file_path)
                            values_string = "--set imageTag={},game=Valheim,map={},mapSet={},volumeId={},requestsMemory={},limitsMemory={},backupStorageName={},resourceBucketName={},environmentVariableFile={},{},{},{},{},{},{}" \
                                            .format(
                                                image_version, \
                                                map, \
                                                map, \
                                                map_info["volume_id"], \
                                                map_info["requests_memory"], \
                                                map_info["limits_memory"], \
                                                "jks-gs-{}-{}-minecraft-{}-backup-bucket".format(env,region,map), \
                                                "jks-gs-{}-{}-minecraft-{}-gameresources-bucket".format(env,region,map), \
                                                env_file, \
                                                gp1_port_string, \
                                                gp2_port_string, \
                                                gp3_port_string, \
                                                gp1_udp_port_string, \
                                                gp2_udp_port_string, \
                                                gp3_udp_port_string)
                            call_command = ["{}/helm_deploy.sh".format(dir_path), "-g", "Valheim", "-m", map,"-e", env, "-v", values_string]
                            if test:
                                call_command.append("-t")
                            call(call_command)
                            os.remove(env_file_path)
    return ports

if __name__ == '__main__':
    # test1.py executed as script
    # do something

    # Remove 1st argument from the
    # list of command line arguments
    argumentList = sys.argv[1:]
    
    # Options
    options = "t"
    
    # Long options
    long_options = ["mappings-file=", "config-file=", "env="]

    mappings_file = None
    config_file = None
    env = None
    test = False
    region = None

    try:
        # Parsing argument
        arguments, values = getopt.getopt(argumentList, options, long_options)
        # checking each argument
        for currentArgument, currentValue in arguments:

            if currentArgument == "--mappings-file":
                mappings_file = currentValue

            elif currentArgument == "--config-file":
                config_file = currentValue

            elif currentArgument == "--env":
                env = currentValue

            elif currentArgument == "--region":
                region = currentValue

            elif currentArgument == "-t":
                test = True
                
    except getopt.error as err:
        # output error, and return with an error code
        print (str(err))

    if (mappings_file is None) or (config_file is None) or (region is None) or (env is None):
        sys.exit("Either --mappings-file, --config-file, --region, or --env were not provided.")

    apply_charts(mappings_file, config_file, env, region, test)