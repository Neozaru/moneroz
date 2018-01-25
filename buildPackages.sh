#!/bin/bash
set -e

BASE_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CUSTOM_REPOSITORY_LOCATON=$BASE_DIRECTORY/custom/repository
export MAKEFLAGS="-j $( grep -c ^processor /proc/cpuinfo )"

mkdir -p $CUSTOM_REPOSITORY_LOCATON

package() {
  pushd $1 && git clean -fd && makepkg -f ; popd
  cp $1/*.pkg.tar.xz $CUSTOM_REPOSITORY_LOCATON/
}

package monero-git-packager
package monero-gui-git-packager
package kovri-git-packager

pushd $CUSTOM_REPOSITORY_LOCATON && repo-remove moneroz.db.tar.gz ; repo-add moneroz.db.tar.gz *.pkg.tar.xz ; popd
