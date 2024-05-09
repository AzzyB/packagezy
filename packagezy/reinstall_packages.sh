#!/bin/bash

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
