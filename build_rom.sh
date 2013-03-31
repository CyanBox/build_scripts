#!/bin/bash

# bash script to build CyanBox ROM

# Colorize and add text parameters
red=$(tput setaf 1)             #  red
grn=$(tput setaf 2)             #  green
cya=$(tput setaf 6)             #  cyan
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) #  red
bldgrn=${txtbld}$(tput setaf 2) #  green
bldblu=${txtbld}$(tput setaf 4) #  blue
bldcya=${txtbld}$(tput setaf 6) #  cyan
txtrst=$(tput sgr0)             # Reset

USAGE="${cya}build_rom.sh [maguro] [sync] [4] [clean]${txtrst}"
ROM="cyanbox"

if [ "$1" == "" ]
then
	echo -e "${grn}building for default device - maguro ${txtrst}"
	DEVICE="maguro"
else
	DEVICE="$1"
fi

SYNC="$2"
THREADS="$3"
CLEAN="$4"

# Build Date/Version
VERSION=`date +%Y%m%d`

# Time of build startup
res1=$(date +%s.%N)

echo -e "Building ${cya}$ROM $VERSION ${txtrst}";

# sync with latest sources
echo -e ""
if [ "$SYNC" == "sync" ]
then
   echo -e "${bldblu}Syncing latest sources ${txtrst}"
   repo sync -j"$THREADS"
   echo -e ""
fi

# setup environment
if [ "$CLEAN" == "clean" ]
then
   echo -e "${bldblu}Cleaning up out folder ${txtrst}"
   make clobber;
else
  echo -e "${bldblu}Skipping out folder cleanup ${txtrst}"
fi

# setup environment
echo -e "${bldblu}Setting up build environment ${txtrst}"
. build/envsetup.sh

# lunch device
echo -e ""
echo -e "${bldblu}Lunching your device ${txtrst}"
lunch "$ROM_$DEVICE-userdebug";

echo -e ""
echo -e "${bldblu}Starting build for $DEVICE ${txtrst}"

# start compilation
brunch "$ROM_$DEVICE-userdebug" -j"$THREADS";
echo -e ""

# finished? get elapsed time
res2=$(date +%s.%N)
echo "${bldgrn}Total time elapsed: ${txtrst}${grn}$(echo "($res2 - $res1) / 60"|bc ) minutes ($(echo "$res2 - $res1"|bc ) seconds) ${txtrst}"
