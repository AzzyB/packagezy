#!/bin/bash

# Function to log installed packages and applications
log_installed_packages() {
    # Check package manager and install the necessary command
    if command -v dpkg &>/dev/null; then
        package_manager="dpkg -l"
    elif command -v rpm &>/dev/null; then
        package_manager="rpm -qa"
    else
        echo "Error: Unsupported package manager. Please install 'dpkg' or 'rpm' and run the script again."
        exit 1
    fi

    # Log installed packages to a file named 'installed_packages.log'
    $package_manager > installed_packages.log
    echo "Installed packages and applications logged to 'installed_packages.log'"
}

# Function to reinstall packages and applications on another system
reinstall_packages() {
    # Check package manager and use the appropriate command to reinstall packages
    if command -v apt-get &>/dev/null; then
        package_manager="apt-get install -y"
    elif command -v dnf &>/dev/null; then
        package_manager="dnf install -y"
    elif command -v yum &>/dev/null; then
        package_manager="yum install -y"
    else
        echo "Error: Unsupported package manager. Please install 'apt-get', 'dnf', or 'yum' and run the script again."
        exit 1
    fi

    # Reinstall packages listed in 'installed_packages.log'
    if [ -f "installed_packages.log" ]; then
        $package_manager $(cat installed_packages.log | awk '{print $2}')
    else
        echo "Error: 'installed_packages.log' not found. Run the script with the 'log' argument first."
        exit 1
    fi

    echo "Packages and applications reinstalled."
}

# Main script starts here

if [ "$1" = "log" ]; then
    log_installed_packages
elif [ "$1" = "reinstall" ]; then
    reinstall_packages
else
    echo "Usage: $0 [log | reinstall]"
    exit 1
fi


