#!/bin/bash
set -e

BASE_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILD_DIRECTORY=$PWD/build

ARCHISO_CONFIG_DIRECTORY=$BASE_DIRECTORY/archiso/configs/releng/
CUSTOMIZATIONS_DIRECTORY=$BASE_DIRECTORY/custom
CUSTOM_REPOSITORY_LOCATON=$CUSTOMIZATIONS_DIRECTORY/repository/
TARGET_SYSTEM_ROOT=$BUILD_DIRECTORY/moneroz/airootfs/


# Retrieving original Archlinux install, Monero and Kovri repositories
git submodule update --init --recursive

# Cleanup
rm -rf $BUILD_DIRECTORY/ && mkdir -p $BUILD_DIRECTORY/moneroz

# Setup
mkdir -p $CUSTOM_REPOSITORY_LOCATON
cp -R $ARCHISO_CONFIG_DIRECTORY/* $BUILD_DIRECTORY/moneroz

# Adds local custom repostory to packages manager configuration
cat $CUSTOMIZATIONS_DIRECTORY/extrarepository.pacman.conf | sed 's@{{CUSTOM_REPOSITORY_LOCATON}}@'"$CUSTOM_REPOSITORY_LOCATON"'@' >> $BUILD_DIRECTORY/moneroz/pacman.conf

# Boot screen
cp $CUSTOMIZATIONS_DIRECTORY/moneroSplash.jpg $BUILD_DIRECTORY/moneroz/syslinux/splash.png
sed -i 's/Arch Linux/MoneroZ/g' $BUILD_DIRECTORY/moneroz/syslinux/*.cfg

# Adds extra packages (Xfce) to Archlinux base build
cat $CUSTOMIZATIONS_DIRECTORY/extrapackages.both >> $BUILD_DIRECTORY/moneroz/packages.both

echo $TARGET_SYSTEM_ROOT/root/customize_airootfs.sh
# Adds default user
echo 'useradd -m -p "" -g users -G "adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel" -s /usr/bin/zsh user' >> $TARGET_SYSTEM_ROOT/root/customize_airootfs.sh
# Auto-login the default user
sed -i 's/--autologin root/--autologin user/g' $TARGET_SYSTEM_ROOT/etc/systemd/system/getty@tty1.service.d/autologin.conf
# Enables desktop on boot (xfce)
mkdir -p $TARGET_SYSTEM_ROOT/etc/skel/
echo 'exec startxfce4' > $TARGET_SYSTEM_ROOT/etc/skel/.xinitrc
sed -i 's/systemctl set-default multi-user.target/systemctl set-default graphical.target/g' $TARGET_SYSTEM_ROOT/root/customize_airootfs.sh

pushd $BUILD_DIRECTORY/moneroz &&
  ./build.sh -N moneroz -V 0.0.1 -L MONEROZ_0.0.1 -D moneroz -o $BUILD_DIRECTORY/ -v ;
  popd

