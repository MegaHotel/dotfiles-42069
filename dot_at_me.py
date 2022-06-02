import os
from pathlib import Path
from distutils.dir_util import copy_tree
from service_map import service_map, FilesPaths, all_services
from cli import parser

if __name__ == "__main__":
    args = parser.parse_args()
    mode = args.mode[0]
    services = args.services
    home_dir = Path.home()
    config_dir = f"{home_dir}/.config"
    cwd = os.path.abspath(os.path.dirname(__file__))
    source_dir = f"{cwd}/.config"

    for service_name in services:
        if service_name not in all_services:
            raise ValueError(f'No idea what "{service_name}" is....')
        service: FilesPaths = service_map[service_name]

        target_path = f"{config_dir}/{service['folder_path']}"
        source_path = f"{source_dir}/{service['folder_path']}"
        if mode == "produce":
            print(f"Copying everything from {target_path} to {source_path}")
            copy_tree(target_path, source_path)
        elif mode == "consume":
            print(f"Copying everything from {source_path} to {target_path}")
            copy_tree(source_path, target_path)
