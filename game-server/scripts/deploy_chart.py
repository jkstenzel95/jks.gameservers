import getopt
import json
import sys
import deploy_ark_chart
import deploy_minecraft_chart
import deploy_valheim_chart
from subprocess import call

def deploy_chart_for_games(shared_files_location, env, test):
    config_file = "{}/config/{}.json".format(shared_files_location, env)
    with open(config_file) as cd:
        config_json = json.load(cd)
        for game in config_json["games"]:
            mappings_file = "{}/data/{}_mappings.json".format(shared_files_location, game["name"].lower())
            getattr(sys.modules["deploy_%s_chart" % game["name"].lower()], "apply_charts")(mappings_file, config_file, env, test)

if __name__ == '__main__':
    # test1.py executed as script
    # do something

    # Remove 1st argument from the
    # list of command line arguments
    argumentList = sys.argv[1:]
    
    # Options
    options = "t"
    
    # Long options
    long_options = ["shared-files-location=", "env="]

    shared_files_location = None
    env = None
    test = False

    try:
        # Parsing argument
        arguments, values = getopt.getopt(argumentList, options, long_options)
        
        # checking each argument
        for currentArgument, currentValue in arguments:

            if currentArgument == "--shared-files-location":
                shared_files_location = currentValue

            elif currentArgument == "--env":
                env = currentValue

            elif currentArgument == "-t":
                test = True
                
    except getopt.error as err:
        # output error, and return with an error code
        print (str(err))

    if (shared_files_location is None) or (env is None):
        sys.exit("Either --shared-files-location or --env were not provided.")

    deploy_chart_for_games(shared_files_location, env, test)