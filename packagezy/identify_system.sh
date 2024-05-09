#!/bin/bash

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
