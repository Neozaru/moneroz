#!/bin/bash
set -e

BASE_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker build -t moneroz-builder -f $BASE_DIRECTORY/Dockerfile $BASE_DIRECTORY
[ "$(docker ps -a | grep moneroz)" ] && docker rm moneroz ; 
docker run --privileged --name moneroz moneroz-builder && docker cp moneroz:/home/builduser/build/moneroz*.iso $PWD
