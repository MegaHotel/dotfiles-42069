from typing import TypedDict


class FilesPaths(TypedDict):
    folder_path: str


service_map: dict[str, FilesPaths] = {
    "picom": {
        "folder_path": "picom",
    },
    "i3": {
        "folder_path": "i3",
    },
    "lvim": {
        "folder_path": "lvim",
    },
    "alacritty": {
        "folder_path": "alacritty",
    },
    "btop": {
        "folder_path": "btop",
    },
}

all_services: list[str] = [service_name for service_name in service_map.keys()]
