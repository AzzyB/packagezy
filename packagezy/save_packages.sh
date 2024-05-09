#!/bin/bash

# Function to save the listed packages from all sources to a text file within the same directory as the script
function save_packages {
    echo "$PACKAGE_MANAGER" > packages.txt
    echo "$PACKAGES" >> packages.txt
}
