#!/bin/sh


# install the basics
pacman --noconfirm -Syu
pacman --noconfirm -S archiso sudo git base-devel bash

# add a user for makepkg
useradd -m archiso

# make him sudoer
cat >> /etc/sudoers <<EOF
archiso ALL=(ALL) NOPASSWD: ALL
EOF

# fix sudo: setrlimit(RLIMIT_CORE): Operation not permitted
echo "Set disable_coredump false" > /etc/sudo.conf

# make the bacon
su archiso
cd /archiso
bash make_iso.sh
