#!/bin/bash

# FILE: Packagezy
# USAGE: ./packagezy.sh
#
# DESC:N/A
#
# CREATED: by Azzy on 5/8/2024
# VERSION: 1.0.0

# Import scripts
source ./identify_system.sh
source ./list_packages.sh
source ./save_packages.sh
source ./read_packages.sh
source ./reinstall_packages.sh


# Function to display the menu
function display_menu {
echo "____________________________________________________________________________________________________"
echo "|                                                                                                  |"
echo "|  ______   ______     ______     __  __     ______     ______     ______     ______     __  __    |"
echo "| /\  == \ /\  __ \   /\  ___\   /\ \/ /    /\  __ \   /\  ___\   /\  ___\   /\___  \   /\ \_\ \   |"
echo "| \ \  _-/ \ \  __ \  \ \ \____  \ \  _\"-.  \ \  __ \  \ \ \__ \  \ \  __\   \/_/  /__  \ \____ \  |"
echo "|  \ \_\    \ \_\ \_\  \ \_____\  \ \_\ \_\  \ \_\ \_\  \ \_____\  \ \_____\   /\_____\  \/\_____\ |"
echo "|   \/_/     \/_/\/_/   \/_____/   \/_/\/_/   \/_/\/_/   \/_____/   \/_____/   \/_____/   \/_____/ |"
echo "|                                                                                                  |"
echo "|__________________________________________________________________________________________________|"
echo "|                                                                                                  |"
echo "|  Packagezy is a terminal script tool that helps the user log their system packages in a simple   |"
echo "|  way and prepare them for reinstall. The idea behind this is to automate the reinstallation of   |"
echo "|  system packages (and flatpaks) when doing something like upgrading your distro version or       |"
echo "|  changing systems.                                                                               |"
echo "|__________________________________________________________________________________________________|"
echo "|                                              Menu                                                |"
echo "|                                                                                                  |"
echo "|               1) Save packages                                                                   |"
echo "|               2) View saved packages                                                             |"
echo "|               3) Reinstall saved packages                                                        |"
echo "|               4) Exit                                                                            |"
echo "|__________________________________________________________________________________________________|"
echo "                                                                                                    "
}

# Main loop
while true; do
    display_menu
    read -p "Choose an option: " option
    case $option in
        1)
            identify_system
            list_packages
            save_packages
            ;;
        2)
            cat packages.txt
            ;;
        3)
            read_packages
            reinstall_packages
            ;;
        4)
            exit 0
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done
