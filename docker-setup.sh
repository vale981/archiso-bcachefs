#!/bin/bash

docker run \
  -i \
  --rm --privileged=true \
  --name archiso \
  --mount type=bind,source="$(pwd)",target=/archiso \
  archlinux:latest bash  < ./in_docker.sh
