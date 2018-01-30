#!/bin/bash
set -e

BASE_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILD_DIRECTORY=$PWD/build

ARCHISO_CONFIG_DIRECTORY=$BASE_DIRECTORY/archiso/configs/releng/
CUSTOMIZATIONS_DIRECTORY=$BASE_DIRECTORY/custom
CUSTOM_REPOSITORY_LOCATON=$BASE_DIRECTORY/repository/
TARGET_SYSTEM_ROOT=$BUILD_DIRECTORY/moneroz/airootfs/

# Cleanup
rm -rf $BUILD_DIRECTORY/ && mkdir -p $BUILD_DIRECTORY/moneroz

# Setup
cp -R $ARCHISO_CONFIG_DIRECTORY/* $BUILD_DIRECTORY/moneroz

# Adds local custom repostory to packages manager configuration
cat $CUSTOMIZATIONS_DIRECTORY/pacman.conf.append | sed 's@{{CUSTOM_REPOSITORY_LOCATON}}@'"$CUSTOM_REPOSITORY_LOCATON"'@' >> $BUILD_DIRECTORY/moneroz/pacman.conf

# Boot screen
cp $CUSTOMIZATIONS_DIRECTORY/moneroSplash.jpg $BUILD_DIRECTORY/moneroz/syslinux/splash.png
sed -i 's/Arch Linux/MoneroZ/g' $BUILD_DIRECTORY/moneroz/syslinux/*.cfg
sed -i 's/Arch Linux/MoneroZ/g' $BUILD_DIRECTORY/moneroz/efiboot/loader/entries/*.conf
# Adds extra packages (Xfce) to Archlinux base build
cat $CUSTOMIZATIONS_DIRECTORY/packages.both.append >> $BUILD_DIRECTORY/moneroz/packages.both

# Auto-login the default user
sed -i 's/--autologin root/--autologin user/g' $TARGET_SYSTEM_ROOT/etc/systemd/system/getty@tty1.service.d/autologin.conf

# Populate system root with customizations
cp -R $CUSTOMIZATIONS_DIRECTORY/root.append/* $TARGET_SYSTEM_ROOT/

# Populate popinstall script with customizations
cat $CUSTOMIZATIONS_DIRECTORY/customize_airootfs.sh.append >> $TARGET_SYSTEM_ROOT/root/customize_airootfs.sh

# Override mkinitcpio
cp $CUSTOMIZATIONS_DIRECTORY/mkinitcpio.conf.replace $BUILD_DIRECTORY/moneroz

pushd $BUILD_DIRECTORY/moneroz &&
  ./build.sh -N moneroz -V 0.0.1 -L MONEROZ_0.0.1 -D moneroz -o $BUILD_DIRECTORY/ -v ;
  popd

