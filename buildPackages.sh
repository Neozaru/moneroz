#!/bin/bash
set -e

BASE_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CUSTOM_REPOSITORY_LOCATON=$BASE_DIRECTORY/repository
# export MAKEFLAGS="-j $( grep -c ^processor /proc/cpuinfo )"

rm -Rf $CUSTOM_REPOSITORY_LOCATON && mkdir -p $CUSTOM_REPOSITORY_LOCATON

package() {
  pushd $1
  #[ -d .git ] && git clean -df
  rm -Rf ./src ./pkg ./*pkg.tar.xz
  makepkg
  popd
  cp $1/*pkg.tar.xz $CUSTOM_REPOSITORY_LOCATON/
}

package kovri-packager
package monero-gui-packager
#package monero-packager

pushd $CUSTOM_REPOSITORY_LOCATON && repo-add moneroz.db.tar.xz *pkg.tar.xz
popd
