#!/bin/bash

BASE_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILD_DIRECTORY=$PWD/build

ARCHISO_CONFIG_DIRECTORY=$BASE_DIRECTORY/archiso/configs/releng/
CUSTOMIZATIONS_DIRECTORY=$BASE_DIRECTORY/custom/
TARGET_SYSTEM_ROOT=$BUILD_DIRECTORY/moneroz/airootfs/



# Retrieving original Archlinux install, Monero and Kovri repositories
git submodule update --init --recursive

echo 'Submodules updated!'

rm -R $BUILD_DIRECTORY/ && mkdir -p $BUILD_DIRECTORY/moneroz
cp -R $ARCHISO_CONFIG_DIRECTORY/* $BUILD_DIRECTORY/moneroz

mkdir -p $TARGET_SYSTEM_ROOT/usr/bin
#pushd monero-gui && ./build.sh; popd
cp -R ./monero-gui/build/release/bin/* $TARGET_SYSTEM_ROOT/usr/bin
#pushd ./kovri && make ; popd
cp ./kovri/build/kovri $TARGET_SYSTEM_ROOT/usr/bin


echo 'Building ISO...'

# Adds extra packages (Xfce) to Archlinux base build
cat $CUSTOMIZATIONS_DIRECTORY/extrapackages.both >> $BUILD_DIRECTORY/moneroz/packages.both

# Configures the desktip to be Xfce
mkdir -p $TARGET_SYSTEM_ROOT/etc/skel/
echo 'exec startxfce4' > $TARGET_SYSTEM_ROOT/etc/skel/.xinitrc

# Enables desktop on boot
sed -i '/systemctl set-default multi-user.target/c\systemctl set-default graphical.target' $TARGET_SYSTEM_ROOT/root/customize_airootfs.sh

pushd $BUILD_DIRECTORY/moneroz &&
  ./build.sh -N moneroz -V 0.0.1 -L MONEROZ_0.0.1 -D moneroz -o $BUILD_DIRECTORY/ -v ;
  popd