#!/bin/bash
set -e

BASE_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CUSTOM_REPOSITORY_LOCATON=$BASE_DIRECTORY/custom/repository/
MAKEFLAGS="$( grep -c ^processor /proc/cpuinfo )"


package() {
  pushd $1 && makepkg -f ; popd
  cp $1/*.pkg.tar.xz $CUSTOM_REPOSITORY_LOCATON/
}

# package monero-git-packager
# package monero-gui-git-packager
package kovri-git-packager

pushd $CUSTOM_REPOSITORY_LOCATON && repo-remove moneroz.db.tar.gz ; repo-add moneroz.db.tar.gz *.pkg.tar.xz ; popd
