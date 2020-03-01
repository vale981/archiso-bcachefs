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

# more dependencies
cd /tmp
su archiso
git clone https://aur.archlinux.org/libscrypt.git
cd libscrypt
makepkg -si --noconfirm

# make the bacon
cd /archiso
bash make_iso.sh
