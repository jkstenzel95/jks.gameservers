import getopt
import json
import os
import sys
import deployment_utilities
from subprocess import call

def apply_charts(mappings_file, config_file, env, test):
    with open(mappings_file) as md:
        with open(config_file) as cd:
            mappings_json = json.load(md)
            config_json = json.load(cd)
            
            for game in config_json["games"]:
                if game["name"] == "Ark":
                    mod_string = ",".join(str(x) for x in game["mods"])
                    max_players = game["max_players"]
                    map_set = set(game["maps"])
                    image_version = "{}.{}".format(env, game["image_version"])
                    for idx, map_info in enumerate(mappings_json["maps"]):
                        if map_info["name"] in map_set:
                            print("Creating cluster for map {} with code {} and unique server params {}; Image tag {}".format(map_info["name"], map_info["map_code"], map_info["additional_server_params"], image_version))
                            game_port_1 = deployment_utilities.get_port_number(7777, idx)
                            game_port_2 = game_port_1 + 1
                            query_port = deployment_utilities.get_port_number(27015, idx)
                            rcon_port = deployment_utilities.get_port_number(32330, idx)
                            print("We're looking at game ports {} and {} with an RCON port of {} and query port of {}".format(game_port_1, game_port_2, rcon_port, query_port))
                            gp1_port_string = "ports[0].name=SERVER_PORT_1,ports[0].protocol=udp,ports[0].number={}".format(game_port_1)
                            gp2_port_string = "ports[1].name=SERVER_PORT_2,ports[1].protocol=udp,ports[1].number={}".format(game_port_2)
                            query_port_string = "ports[2].name=QUERY_PORT,ports[2].protocol=udp,ports[2].number={}".format(query_port)
                            rcon_port_string = "ports[3].name=RCON_PORT,ports[3].protocol=udp,ports[3].number={}".format(rcon_port)
                            dir_path = os.path.dirname(os.path.realpath(__file__))
                            env_file = "{}_env_list.txt".format(map_info["name"])
                            env_file_path = "{}/../helm/game-server/{}".format(dir_path, env_file)
                            env_dict = { "map_code" : map_info["map_code"], "additional_server_params": map_info["additional_server_params"], "mod_list": mod_string, "max_players": str(max_players) }
                            deployment_utilities.generate_env_file(env_dict, env_file_path)
                            values_string = "--set imageTag={},game=Ark,map={},environmentVariableFile={},{},{},{},{}".format(image_version, map_info["name"], env_file, gp1_port_string, gp2_port_string, query_port_string, rcon_port_string)
                            call_command = ["{}/helm_deploy.sh".format(dir_path), "-g", "Ark", "-m", map_info["name"],"-e", env, "-v", values_string]
                            if test:
                                call_command.append("-t")
                            call(call_command)
                            os.remove(env_file_path)

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

            elif currentArgument == "-t":
                test = True
                
    except getopt.error as err:
        # output error, and return with an error code
        print (str(err))

    if (mappings_file is None) or (config_file is None) or (image_version is None) or (test is False):
        sys.exit("Either --mappings-file, --config-file, --env, or --image-version were not provided.")

    apply_charts(mappings_file, config_file, image_version, env, test)