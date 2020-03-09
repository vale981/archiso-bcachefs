#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

docker run \
  -i \
  --rm --privileged=true \
  --name archiso \
  --mount type=bind,source="$DIR",target=/archiso \
  archlinux:latest bash  < ./in_docker.sh
