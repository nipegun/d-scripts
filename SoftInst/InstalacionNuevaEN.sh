#!/bin/bash

# I make this script publicly available under the term "public domain software."
# You can do whatever you want with it because it is truly free—unlike so-called "free" software with conditions, like the GNU licenses and other similar nonsense.
# If you're so eager to talk about freedom, then make it truly free.
# You don't have to accept any terms of use or license to use or modify it, because it comes with no CopyLeft.

# ----------
# NiPeGun's script to install and configure SkillSelector on Debian
#
# Remote execution (may require sudo privileges):
#   curl -sL x | bash
#
# Remote execution as root (for systems without sudo):
#   curl -sL x | sed 's-sudo--g' | bash
#
# Remote execution without cache:
#   curl -sL -H 'Cache-Control: no-cache, no-store' x | bash
#
# Remote execution with parameters:
#   curl -sL x | bash -s Parámetro1 Parámetro2
#
# Download and edit the file directly in nano:
#   curl -sL x | nano -
# ----------

# Define color constants in Bash (for terminal output):
  cColorBlue='\033[0;34m'
  cColorBlueLight='\033[1;34m'
  cColorGreen='\033[1;32m'
  cColorRed='\033[1;31m'
  cColorEnd='\033[0m'

# Check if the script is running as root
  #if [ $(id -u) -ne 0 ]; then     # Only check if the script is running as root
  if [[ $EUID -ne 0 ]]; then       # Check if the script is running as root or with sudo
    echo ""
    echo -e "${cColorRed}  This script is designed to be run with administrative privileges (as root or using sudo).${cColorEnd}"
    echo ""
    exit
  fi

# Check if the curl package is installed. If it's not, install it:
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRed}  The curl package is not installed. Starting installation...${cColorEnd}"
    echo ""
    sudo apt-get -y update
    sudo apt-get -y install curl
    echo ""
  fi

# Determine the Debian version
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    cOSName=$NAME
    cOSVersion=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    cOSName=$(lsb_release -si)
    cOSVersion=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    cOSName=$DISTRIB_ID
    cOSVersion=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cOSName=Debian
    cOSVersion=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    cOSName=$(uname -s)
    cOSVersion=$(uname -r)
  fi

# Run commands depending on the detected Debian version:

  if [ $cOSVersion == "13" ]; then

    echo ""
    echo -e "${cColorBlueLight}  Starting the installation script of xxxxxxxxx for Debian 13 (x)...${cColorEnd}"
    echo ""

    echo ""
    echo -e "${cColorRed}    Commands for Debian 13 are not yet prepared. Try running this on another Debian version.${cColorEnd}"
    echo ""

  elif [ $cOSVersion == "12" ]; then

    echo ""
    echo -e "${cColorBlueLight}  Starting the installation script of xxxxxxxxx for Debian 12 (Bookworm)...${cColorEnd}"
    echo ""

    echo ""
    echo -e "${cColorRed}    Commands for Debian 12 are not yet prepared. Try running this on another Debian version.${cColorEnd}"
    echo ""

  elif [ $cOSVersion == "11" ]; then

    echo ""
    echo -e "${cColorBlueLight}  Starting the installation script of xxxxxxxxx for Debian 11 (Bullseye)...${cColorEnd}"
    echo ""

    echo ""
    echo -e "${cColorRed}    Commands for Debian 11 are not yet prepared. Try running this on another Debian version.${cColorEnd}"
    echo ""

  elif [ $cOSVersion == "10" ]; then

    echo ""
    echo -e "${cColorBlueLight}  Starting the installation script of xxxxxxxxx for Debian 10 (Buster)...${cColorEnd}"
    echo ""

    echo ""
    echo -e "${cColorRed}    Commands for Debian 10 are not yet prepared. Try running this on another Debian version.${cColorEnd}"
    echo ""

  elif [ $cOSVersion == "9" ]; then

    echo ""
    echo -e "${cColorBlueLight}  Starting the installation script of xxxxxxxxx for Debian 9 (Stretch)...${cColorEnd}"
    echo ""

    echo ""
    echo -e "${cColorRed}    Commands for Debian 9 are not yet prepared. Try running this on another Debian version..${cColorEnd}"
    echo ""

  elif [ $cOSVersion == "8" ]; then

    echo ""
    echo -e "${cColorBlueLight}  Starting the installation script of xxxxxxxxx for Debian 8 (Jessie)...${cColorEnd}"
    echo ""

    echo ""
    echo -e "${cColorRed}    Commands for Debian 8 are not yet prepared. Try running this on another Debian version.${cColorEnd}"
    echo ""

  elif [ $cOSVersion == "7" ]; then

    echo ""
    echo -e "${cColorBlueLight}  Starting the installation script of xxxxxxxxx for Debian 7 (Wheezy)...${cColorEnd}"
    echo ""

    echo ""
    echo -e "${cColorRed}    Commands for Debian 7 are not yet prepared. Try running this on another Debian version.${cColorEnd}"
    echo ""

  fi

