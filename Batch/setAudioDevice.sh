#!/bin/sh
# Script to change Audio Device based on input string.
# First device found that matches string is used.

DEVICE=$1
# SoundVolumeCommandLine - https://www.nirsoft.net/utils/sound_volume_command_line.html
SVCL="/cygdrive/d/bin/NirsoftLauncher/NirSoft/svcl.exe"

# Get list of render devices
RENDER_DEVICES=$($SVCL /scomma | grep "Device,Render" | cut -d "," -f1)

if  [ $# -eq 0 ]; then 
	echo -e "Available audio devices:\n$RENDER_DEVICES"
	exit 0;
fi

# Find the first device matching the string
RENDER_DEVICE=$(echo "$RENDER_DEVICES" | grep -im1 "$DEVICE")

if [ ! -z "$RENDER_DEVICE" ]; then 
	echo "Setting default audio device to $RENDER_DEVICE"
	$SVCL /SetDefault "$RENDER_DEVICE"
else
	echo "Device not found!"
	exit 1;
fi
