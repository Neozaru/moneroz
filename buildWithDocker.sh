#!/bin/bash
set -e

BASE_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker build -t moneroz-builder -f $BASE_DIRECTORY/Dockerfile $BASE_DIRECTORY
[ "$(docker ps -a | grep moneroz)" ] && docker rm moneroz ;
# TODO: Hardcoded source/destination 
docker run --privileged --name moneroz moneroz-builder && 
  docker cp moneroz:/home/builduser/build/moneroz-0.0.1-x86_64.iso $PWD
