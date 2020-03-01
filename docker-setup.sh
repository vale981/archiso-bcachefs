#!/bin/bash
cd $DIR

docker run \
  -i \
  --rm --privileged=true \
  --name archiso \
  --mount type=bind,source="$DIR",target=/archiso \
  archlinux:latest bash  < ./in_docker.sh
