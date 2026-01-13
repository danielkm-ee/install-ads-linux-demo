# Setting up ADS on Linux
For linux users, here is how I've set up my installation of ADS. This is my preference, so follow at your own discretion.
My goal is to help anyone struggling to get ADS working on their machine, or make launching/using ADS a bit more seamless.

Will try to keep this short and sweet!

> Most of this is pulled from [Keysight's setup guide](https://docs.keysight.com/display/engdocads/ADS+2025+Quick+Install-Linux)

## Setting up the license server:
It seems to me that this a process in the background that lets ADS confirm this machine has a license. Anyway,
Keysight wants this running so let's start it.

### Storing our license somewhere safe
In order to start using your license, first you should find a good place to put it! You want it to be easy to find.

When we run the setup utility from keysight they will want the location of your license file, and a place to log debug messages for licensing issues.

For my install I made two folders in the default installation directory:
```
$ cd /usr/local/ADS2026_Update1/Licensing
$ mkdir ./lic     # place where I'll store my license.lic
$ mkdir ./log     # place where I'll designate a .log file
$ touch ./log/lic-debug.log
```
You can rename your license file if you'd like, I left mine with the long name it came with and it got a bit annoying.

### Starting the license server
Now that we have our license stored, we can run their utility to setup our 'license server' like so:
> this assumes your working directory is still `/usr/local/ADS2026_Update1/Licensing`! use `$ pwd` to check this.
```
$ cd 2025.4/linux_x86_64/bin/
$ ./lmgrd /usr/local/ADS2026_Update1/Licensing/lic/license.lic -l /usr/local/ADS2026_Update1/Licensing/log/lic-debug.log
```
> Note: Make sure you have those filepaths correct if you changed anything previously.
Now we should have our license server active on our machine. 


## Setting up Keysight Environment Variables
Whenever we launch ADS, the program will look for your license file and the ADS executables. In order for it to find
these, we have to add them to our shell environent, usually bash -- as is my case.

Here is what I added to my ~/.bashrc:
```
# keysight ads variables
#     without these, ads wont be able to find your license file, and it may run into functional issues but I haven't tested that.
#     make sure HPEESOF_DIR matches your install location, and update the name of your license file
export HPEESOF_DIR=/usr/local/ADS2026_Update1
export ADS_LICENSE_DIR=$HPEESOF_DIR/Licensing/2025.4/linux_x86_64
export ADS_LICENSE_FILE=$HPEESOF_DIR/Licensing/lic/license.lic

export PATH=$HPEESOF_DIR/bin:$PATH
export PATH=$ADS_LICENSE_DIR/bin:$PATH
```
It's important that `ADS_LICENSE_DIR` points to your license file, update the path there if needed!
The last two lines make the ADS programs executable from any shell. After adding this to your .bashrc and opening a new shell, you can now
start running ADS using `$ ads`

You could totally stop here if you want to! The next section makes the ADS program show up when you search "Keysight ADS" in your desktop environments search bar, so I 
do reccommend following through there as well.  
> If you run into issues here, you may need to install the KorneShell: `$ sudo apt install ksh`. not sure why, but the ads executable expects a ksh shell environment.  
> If this doesn't fix your issue, double check that the previous steps have been followed correctly, and feel free to reach out to me on discord


## Adding a Desktop Entry for Keysight ADS
The following steps are basically registering ADS as an application for your desktop environment.

### Using a script to launch ADS
This allows us to create the environment variables needed by ADS, and lets us choose the location where ADS is run from.
I reccommend making a folder for ADS in either ~/Documents/ADS or ~/Applications/ADS, as it will create workspaces and config files
wherever it is executed.

Here is the script I've made:
```
#!/usr/bin/env bash
# filename: start_ads.sh

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
source $HPEESOF_DIR/bin/ads
```
You can download and edit it as needed. I reccomend storing this wherever you plan to run ads, i.e. ~/Documents/ADS or etc.
> Another option would be to store this in `/usr/local/ADS2026_Update1/`, or wherever you see fit

In order to run this script we have to make is executable using the following command:
```
chmod +x ./start_ads.sh
```

### Making the .desktop file
A little-known mechanism underlying your desktop environment is a system created by freedesktop.org.
When you search for applications in drun or gnome, this is the system that's being used to find and execute them.

Each application usually creates it's own `.desktop` file in `~/.local/share/applications` or `/usr/share/applications`.
I won't explain too much here, but I've made a `.desktop` file for ads that you can use as-is or customize yourself. Just copy this or download the one I've provided and
store it in `~/.local/share/applications`.

Here is `ads.desktop`:
```
[Desktop Entry]
Version=2026.1
Name=Keysight ADS
Type=Application
Exec=/usr/bin/env ADS_NO_BACKGROUND=on /home/<ENTER USERNAME HERE>/Applications/KeysightADS/start_ads.sh
Path=/home/<ENTER USERNAME HERE>/Applications/KeysightADS
Icon=/usr/local/ADS2026_Update1/doc/images/keysightlogo.png
Terminal=false
Categories=Development
```
What this file essentially does is two things:  
1. Creates a searchable application entry called 'Keysight ADS'  
2. Runs the start_ads.sh script we created when we execute it

Now you should have a working installation of ADS that works like your other applications :)  
> Notice: This document and the included scripts may undergo updates in the near future!

--------------
> Last updated jan 13th 2026 - danielkm-ee@github.com

> thanks to https://github.com/markdowncss/retro for css theme used to render the pdf version
