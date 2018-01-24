#!/bin/bash
set -e


MAKEFLAGS="$( grep -c ^processor /proc/cpuinfo )"

BASE_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILD_DIRECTORY=$PWD/build

ARCHISO_CONFIG_DIRECTORY=$BASE_DIRECTORY/archiso/configs/releng/
CUSTOMIZATIONS_DIRECTORY=$BASE_DIRECTORY/custom
CUSTOM_REPOSITORY_LOCATON=$CUSTOMIZATIONS_DIRECTORY/repository/
TARGET_SYSTEM_ROOT=$BUILD_DIRECTORY/moneroz/airootfs/



package() {
  pushd $1 && makepkg -f ; popd;
  cp $1/*.pkg.tar.xz $CUSTOM_REPOSITORY_LOCATON/
}


# Retrieving original Archlinux install, Monero and Kovri repositories
git submodule update --init --recursive

echo 'Submodules updated!'

rm -rf $BUILD_DIRECTORY/ && mkdir -p $BUILD_DIRECTORY/moneroz
cp -R $ARCHISO_CONFIG_DIRECTORY/* $BUILD_DIRECTORY/moneroz
cat $CUSTOMIZATIONS_DIRECTORY/extrarepository.pacman.conf | sed 's@{{CUSTOM_REPOSITORY_LOCATON}}@'"$CUSTOM_REPOSITORY_LOCATON"'@' >> $BUILD_DIRECTORY/moneroz/pacman.conf
# mkdir -p $TARGET_SYSTEM_ROOT/usr/bin
# mkdir -p $TARGET_SYSTEM_ROOT/usr/lib
# #pushd monero-gui && ./build.sh; popd
# #cp -R ./monero-gui/build/release/bin/* $TARGET_SYSTEM_ROOT/usr/bin
# mkdir -p ./kovri/build && 
#   pushd ./kovri/build &&
#   cmake -DWITH_BINARY=ON -DKOVRI_DATA_PATH=/etc/kovri.conf -DCMAKE_INSTALL_PREFIX=$TARGET_SYSTEM_ROOT/ -DWITH_CPPNETLIB=ON -DWITH_LIBRARY=ON -DWITH_STATIC=ON -DCMAKE_BUILD_TYPE=Release .. && 
#   make clean install -j$NUMBER_OF_CORES ; 
#   popd
# mkdir -p ./kovri/deps/cpp-netlib/build &&
#   pushd ./kovri/deps/cpp-netlib/build &&
#   cmake -DCMAKE_INSTALL_PREFIX=$TARGET_SYSTEM_ROOT/ .. &&
#   make clean install -j$NUMBER_OF_CORES ; 
#   popd
# mkdir -p $TARGET_SYSTEM_ROOT/usr/bin/
# cp ./kovri/build/kovri $TARGET_SYSTEM_ROOT/usr/bin/
# cp ./kovri/deps/cpp-netlib/build/libs/network/src/*.so $TARGET_SYSTEM_ROOT/usr/lib/
# pushd ./kovri/deps/cpp-netlib/build/ && make install -j$NUMBER_OF_CORES DESTDIR=$BUILD_DIRECTORY/rootfs ; popd
# cp -R $BUILD_DIRECTORY/rootfs/*.so* $TARGET_SYSTEM_ROOT/



# pushd kovri-git-packager && makepkg -f ; popd
# cp kovri-git-packager/*.pkg.tar.xz $CUSTOM_REPOSITORY_LOCATON



# echo 'Building ISO...'
package monero-git-packager
package monero-wallet-gui-git-packager
package kovri-git-packager

pushd $CUSTOM_REPOSITORY_LOCATON && repo-remove moneroz.db.tar.gz ; repo-add moneroz.db.tar.gz *.pkg.tar.xz ; popd

# Adds extra packages (Xfce) to Archlinux base build
cat $CUSTOMIZATIONS_DIRECTORY/extrapackages.both >> $BUILD_DIRECTORY/moneroz/packages.both

# Configures the desktip to be Xfce
mkdir -p $TARGET_SYSTEM_ROOT/etc/skel/
echo 'exec startxfce4' > $TARGET_SYSTEM_ROOT/etc/skel/.xinitrc

# Enables desktop on boot
echo 'id user && useradd -m -p "" -g users -G "adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel" -s /usr/bin/zsh user' > $TARGET_SYSTEM_ROOT/root/customize_airootfs.sh
sed -i '/systemctl set-default multi-user.target/c\systemctl set-default graphical.target' $TARGET_SYSTEM_ROOT/root/customize_airootfs.sh
sed -i '/--autologin root/c\--autologin user' > $TARGET_SYSTEM_ROOT/etc/systemd/system/getty@tty1.service.d/autologin.conf

pushd $BUILD_DIRECTORY/moneroz &&
  ./build.sh -N moneroz -V 0.0.1 -L MONEROZ_0.0.1 -D moneroz -o $BUILD_DIRECTORY/ -v ;
  popd

