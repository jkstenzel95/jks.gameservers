import getopt
import json
import os
import sys
import deploy_ark_chart
import deploy_minecraft_chart
import deploy_valheim_chart
from subprocess import call

def deploy_chart_for_games(shared_files_location, env, test):
    config_file = "{}/config/{}.json".format(shared_files_location, env)
    ports = []
    call_command = ["helm", "repo", "add", "secrets-store-csi-driver", "https://raw.githubusercontent.com/kubernetes-sigs/secrets-store-csi-driver/master/charts"]
    call(call_command)
    call_command = ["helm", "upgrade", "--install", "-n", "kube-system", "csi-secrets-store", "secrets-store-csi-driver/secrets-store-csi-driver"]
    call(call_command)
    call_command = ["kubectl", "apply", "-f", "https://raw.githubusercontent.com/aws/secrets-store-csi-driver-provider-aws/main/deployment/aws-provider-installer.yaml"]
    call(call_command)
    with open(config_file) as cd:
        config_json = json.load(cd)
        for game in config_json["games"]:
            mappings_file = "{}/data/{}_mappings.json".format(shared_files_location, game["name"].lower())
            ports += getattr(sys.modules["deploy_%s_chart" % game["name"].lower()], "apply_charts")(mappings_file, config_file, env, test)
    dir_path = os.path.dirname(os.path.realpath(__file__))
    ports_string = ""
    for idx, port in enumerate(ports):
        if idx != 0:
            ports_string += ","
        ports_string += "ports[{}].name={},ports[{}].protocol={},ports[{}].number={},ports[{}].game={},ports[{}].map={},ports[{}].idx={}".format(idx, port["name"], idx, port["protocol"], idx, port["number"], idx, port["game"], idx, port["map"], idx, idx)
    values_string = "--set {},env={}".format(ports_string, env)
    call_command = ["{}/helm_deploy_loadbalancer.sh".format(dir_path), "-v", values_string]
    if test:
        call_command.append("-t")
    call(call_command)

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