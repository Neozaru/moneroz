#!/bin/bash
set -e

BASE_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CUSTOM_REPOSITORY_LOCATON=$BASE_DIRECTORY/custom/repository/
export MAKEFLAGS="-j $( grep -c ^processor /proc/cpuinfo )"


package() {
  pushd $1 && makepkg -f ; popd
  cp $1/*.pkg.tar.xz $CUSTOM_REPOSITORY_LOCATON/
}

# TODO: Fix monero-git to not crash when repository already exists
rm -Rf monero-git-packager/monero

package monero-git-packager
package monero-gui-git-packager
package kovri-git-packager

pushd $CUSTOM_REPOSITORY_LOCATON && repo-remove moneroz.db.tar.gz ; repo-add moneroz.db.tar.gz *.pkg.tar.xz ; popd
