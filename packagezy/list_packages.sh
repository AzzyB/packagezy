#!/bin/bash

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
