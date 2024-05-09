#!/bin/bash

# Function to read saved list of packages from the stored text file
function read_packages {
    PACKAGE_MANAGER=$(head -n 1 packages.txt)
    PACKAGES=$(tail -n +2 packages.txt)
}
