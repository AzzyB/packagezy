# UNDERGOING REWORK   


## Packagezy

A package handler script by Azzy


#### Version:
    1.0.0

#### Desc:
    This is a short and simple bash script that will parse and generate a log file of all your systems 
    packages and allow you to use that file to reinstall them when doing a system version change. 
    The script should also handle the install commands utilizing the native package manager of a given system.

#### Notes:
    This script is meant to be used of the same distro, so use case may vary. When reinstalling 
    packages be sure to have the script AND the log file in the SAME directory of a given system. 
    Yes, the arguments passed to the script are case sensative and you may need sudo privilege. 

#### Usage
    1.) Make executable: chmod +x Packagezy
    2.) Generate log: ./Packagezy log
    3.) Reinstall packages: ./Packagezy install
