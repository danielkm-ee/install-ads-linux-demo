#!/usr/bin/env bash

# REMINDER: make this script executable with 'chmod +x ./startup_ads.sh'

# keysight ads variables
#     without these, ads wont be able to find your license file, and it may run into functional issues but I haven't tested that.
#     make sure HPEESOF_DIR matches your install location, and update the name of your license file
export HPEESOF_DIR=/usr/local/ADS2026_Update1
export ADS_LICENSE_DIR=$HPEESOF_DIR/Licensing/2025.4/linux_x86_64
export ADS_LICENSE_FILE=$HPEESOF_DIR/Licensing/lic/<license filename>.lic
export PATH=$HPEESOF_DIR/bin:$PATH
export PATH=$ADS_LICENSE_DIR/bin:$PATH

# here we enter a directory where you want ads to be running in.
#     this is where it will be storing workspaces, configs, etc. so something like ~/Documents/ADS or ~/Applications/ADS would be a good fit.
#     otherwise it will make a mess of your home directory ~/
cd $HOME/Applications/KeysightADS/

# here we are launching the ads application, godspeed
exec $HPEESOF_DIR/bin/ads

