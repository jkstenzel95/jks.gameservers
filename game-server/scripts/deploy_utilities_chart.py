import getopt
import sys
from subprocess import call

def deploy_chart_for_utilities(test):
    call_command = ["helm", "repo", "add", "secrets-store-csi-driver", "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"]
    call(call_command)
    call_command = ["helm", "upgrade", "--install", "-n", "kube-system", "csi-secrets-store", "secrets-store-csi-driver/secrets-store-csi-driver"]
    if test:
        call_command.append("--dry-run")
    call(call_command)
    call_command = ["kubectl", "apply", "-f", "https://raw.githubusercontent.com/aws/secrets-store-csi-driver-provider-aws/main/deployment/aws-provider-installer.yaml"]
    if test:
        call_command.append("--dry-run=\"client\"")
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
    long_options = []

    test = False

    try:
        # Parsing argument
        arguments, values = getopt.getopt(argumentList, options, long_options)
        
        # checking each argument
        for currentArgument, currentValue in arguments:
            if currentArgument == "-t":
                test = True
                
    except getopt.error as err:
        # output error, and return with an error code
        print (str(err))

    deploy_chart_for_utilities(test)