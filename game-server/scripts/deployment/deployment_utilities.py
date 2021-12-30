def get_port_number(base_port, map_number):
    return base_port + map_number * 2

def generate_env_file(mappings, file_location):
    q = "\""
    with open(file_location, 'w') as env_file:
        for key, value in mappings.items():
            env_file.write("- name: " + q+(key).upper()+q + "\n")
            env_file.write("  value: " + q+value+q + "\n")