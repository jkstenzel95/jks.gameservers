import getopt
import json
import os
import sys

def apply_charts(mappings_file, config_file):
    sys.exit("ERROR: Valheim servers not yet supported!")

if __name__ == '__main__':
    # test1.py executed as script
    # do something

    # Remove 1st argument from the
    # list of command line arguments
    argumentList = sys.argv[1:]
    
    # Options
    options = "hmo:"
    
    # Long options
    long_options = ["mappings-file=", "config-file="]

    mappings_file = None
    config_file = None

    try:
        # Parsing argument
        arguments, values = getopt.getopt(argumentList, options, long_options)
        
        # checking each argument
        for currentArgument, currentValue in arguments:

            if currentArgument == "--mappings-file":
                mappings_file = currentValue

            elif currentArgument == "--config-file":
                config_file = currentValue
                
    except getopt.error as err:
        # output error, and return with an error code
        print (str(err))

    if (mappings_file is None) or (config_file is None):
        sys.exit("Either --mappings-file or --config-file were not provided.")

    apply_charts(mappings_file, config_file)