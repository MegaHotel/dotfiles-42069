import argparse
from service_map import all_services

parser = argparse.ArgumentParser(
    description="Get some dots!", formatter_class=argparse.RawTextHelpFormatter
)


def bold(text: str) -> str:
    return f"\033[1m{text}\033[0m"


parser.add_argument(
    "mode",
    type=str,
    nargs=1,
    help=(
        "Copying mode:\n"
        f"   {bold('consume')} - copy from repository to local config folder\n"
        f"   {bold('produce')} - copy from local config folder to repository"
    ),
    choices=["produce", "consume"],
)

parser.add_argument(
    "services",
    metavar="SERVICES",
    type=str,
    nargs="*",
    help="Specific services",
    default=all_services,
)
