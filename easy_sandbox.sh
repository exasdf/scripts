#!/bin/bash

SANDBOX_PATH=/home/$USER/carcel
STAGING_PATH=/home/$USER/staging
IMAGE_PATH=/home/$USER/image.iso

unmount_devices()
{
	umount $SANDBOX_PATH/dev
	umount $SANDBOX_PATH/proc
	umount $SANDBOX_PATH/sys
}

clean_leftovers()
{
	if [ -d "$SANDBOX_PATH" ]; 
	then
		echo "Resetting the sandbox..."
		sudo rm -rf $SANDBOX_PATH;
	fi
}

prepare_environment()
{
	echo "Preparing environmenti..."
        mkdir $SANDBOX_PATH
        mkdir $STAGING_PATH

	#Prepping the image
	mount -o loop $IMAGE_PATH $STAGING_PATH
	#Extracting the file system
	unsquashfs -f -d $SANDBOX_PATH/ $STAGING_PATH/casper/filesystem.squashfs

	#removing left over after setup
	umount $STAGING_PATH
	rmdir $STAGING_PATH
}

load_software ()
{
	echo "Loading software..."
	cp /home/ex/google-chrome-stable_current_amd64.deb $SANDBOX_PATH/tmp/
	cp /etc/resolv.conf $SANDBOX_PATH/etc/resolv.conf
}

mount_devices ()
{
	echo "Mounting devices..."
        mount --bind /dev dev
        mount -t proc proc proc
        mount -t sysfs sysfs sys
}

#Making sure environment is clean before starting
unmount_devices
clean_leftovers
prepare_environment

#loading software
load_software

#Starting chroot jail
chroot $SANDBOX_PATH bash

#Acquiring network capabilities
mount_devices
