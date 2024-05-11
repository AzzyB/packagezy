#!/bin/bash

# FILE: Packagezy
# USAGE: ./packagezy.sh
#
# DESC:
# Packagezy is a terminal script tool that helps the user log their system packages in a simple
# way and prepare them for reinstall. The idea behind this is to automate the reinstallation of
# system packages (and flatpaks) when doing something like upgrading your distro version or
# changing systems.
#
# CREATED: by Azzy on 5/8/2024
# VERSION: 1.0.0

# Function to identify the system and the appropriate package manager to use
function identify_system {
    if [ -f /etc/debian_version ]; then
        PACKAGE_MANAGER="apt-get"
    elif [ -f /etc/redhat-release ]; then
        PACKAGE_MANAGER="yum"
    elif [ -f /etc/arch-release ]; then
        PACKAGE_MANAGER="pacman"
    else
        echo "Unsupported system"
        exit 1
    fi
}

# Function to list all installed packages from package manager and third parties like flatpak
function list_packages {
    if [ "$PACKAGE_MANAGER" == "apt-get" ]; then
        PACKAGES=$(dpkg --get-selections | awk '{print $1}')
    elif [ "$PACKAGE_MANAGER" == "yum" ]; then
        PACKAGES=$(yum list installed | awk '{print $1}')
    elif [ "$PACKAGE_MANAGER" == "pacman" ]; then
        PACKAGES=$(pacman -Qq)
    fi

    # Add flatpak packages if flatpak is installed
    if command -v flatpak > /dev/null; then
        FLATPAK_PACKAGES=$(flatpak list --app --columns=application)
        PACKAGES="$PACKAGES $FLATPAK_PACKAGES"
    fi
}

# Function to determine the system and appropriate file manager/app
function check_system {
    if type "xdg-open" > /dev/null; then
        FILE_MANAGER="xdg-open"
    elif [[ "$XDG_CURRENT_DESKTOP" =~ "GNOME" ]]; then
        FILE_MANAGER="nautilus"
    elif [[ "$XDG_CURRENT_DESKTOP" =~ "KDE" ]]; then
        FILE_MANAGER="dolphin"
    elif [[ "$XDG_CURRENT_DESKTOP" =~ "XFCE" ]]; then
        FILE_MANAGER="thunar"
    elif [[ "$XDG_CURRENT_DESKTOP" =~ "LXDE" ]]; then
        FILE_MANAGER="pcmanfm"
    else
        echo "Unable to determine the file manager."
        exit 1
    fi
}

# Function to determine the current active working directory of the script
function get_working_directory {
    WORKING_DIRECTORY=$(pwd)
}

# Function to check if the Package_Logs directory exists and create it if it doesn't
function check_directory {
    if [ ! -d "${WORKING_DIRECTORY}/Package_Logs" ]; then
        mkdir "${WORKING_DIRECTORY}/Package_Logs"
    fi
}

# Function to open the Package_Logs directory with the appropriate file manager
function open_directory {
    $FILE_MANAGER "${WORKING_DIRECTORY}/Package_Logs"
}

# Function to read saved list of packages from the stored text file
function read_packages {
    PACKAGE_MANAGER=$(head -n 1 packages.txt)
    PACKAGES=$(tail -n +2 packages.txt)
}

# Function to re-install all packages listed using the appropriate system package manager
function reinstall_packages {
    if [ "$PACKAGE_MANAGER" == "apt-get" ]; then
        sudo apt-get install --reinstall $PACKAGES
    elif [ "$PACKAGE_MANAGER" == "yum" ]; then
        sudo yum reinstall $PACKAGES
    elif [ "$PACKAGE_MANAGER" == "pacman" ]; then
        sudo pacman -S --needed $PACKAGES
    fi

    # Reinstall flatpak packages
    for package in $PACKAGES; do
        if [[ $package == *"flatpak"* ]]; then
            flatpak install $package -y
        fi
    done
}

# Function to save the listed packages from all sources to a text file with current date and timestamp in MM-DD-YYYY_HH:MM:SS format
function save_packages {
    # Check if Package_Logs directory exists
    if [ ! -d "Package_Logs" ]; then
        echo "Creating Package_Logs directory..."
        mkdir "Package_Logs" || { echo "Error: Unable to create Package_Logs directory"; return; }
        echo "Package_Logs directory created."
    fi

    # Define file name with current date and timestamp
    FILENAME="Package_Logs/packages_$(date +'%m-%d-%Y_%H-%M-%S').txt"

    # Save package manager and packages to file
    echo "$PACKAGE_MANAGER" > "$FILENAME"
    echo "$PACKAGES" >> "$FILENAME"

    echo "Packages saved to $FILENAME"
}

# Function to display A logo
function display_logo {

echo "           ++++++++            "
echo "       ++++   +    ++++        "
echo "     ++      +++       ++      "
echo "   ++       +++++       ++     "
echo "  ++       +++++++       ++    "
echo " ++       ++++ ++++       ++   "
echo " ++      ++++   ++++       ++  "
echo " ++     ++++      +++      ++  "
echo " ++    ++++        +++     ++  "
echo " ++   ++++          +++    +   "
echo "  ++ +++++            ++       "
echo "   ++ +++++++          ++      "
echo "     ++                  +     "
echo "       ++++               +    "
echo "           +++++++             "
}

# Function to display the menu
function display_menu {

clear

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
echo "| 1) Save Packages            | save all of your system packages to a versioned txt file           |"
echo "| 2) View Logged Packages     | open folder where versioned files are stored                       |"
echo "| 3) Reinstall Packages       | choose versioned file to reinstall packages for                    |"
echo "| 4) Exit                     |                                                                    |"
echo "|__________________________________________________________________________________________________|"
echo "                                                                                                    "
}

clear
display_logo

# Main loop
while true; do
    display_menu
    read -p "Choose an option: " option

        case $option in
        1) identify_system && list_packages && save_packages ;;
        2) check_system && get_working_directory && check_directory && open_directory  ;;
        3) read_packages && reinstall_packages ;;
        4) exit 0 ;;
        *) echo "Invalid option" ;;
     esac

done
