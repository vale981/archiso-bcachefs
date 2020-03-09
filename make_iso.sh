#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

ARCH=x86_64
KERNEL_ARCH=
REPO_DIR=$DIR/repo/$ARCH
REPO=$REPO_DIR/repo.db.tar.gz
PACKAGE_DIR=$DIR/packages
WORKDIR=$DIR/archlive/

echo "Init Workdir"
echo "============"

echo "Removing $WORKDIR"
sudo rm -rf $WORKDIR
cp -r /usr/share/archiso/configs/releng/ $WORKDIR

echo "Patching build.sh"
sed -i 's/vmlinuz-linux/vmlinuz-linux-bcachefs-git/' $WORKDIR/build.sh

echo "Adding Packages"
cat >> $WORKDIR/packages.x86_64 <<EOF
libscrypt-git
bcachefs-tools-git
linux-bcachefs-git
linux-bcachefs-git-headers
linux-bcachefs-git-docs
EOF

echo "Setting up pacman.conf"
cat >> $WORKDIR/pacman.conf <<EOF
[repo]
SigLevel = Optional TrustAll
Server = file:///$REPO_DIR/
EOF

echo "Init Repo"
echo "========="

mkdir -p $REPO_DIR
mkdir -p $PACKAGE_DIR
repo-add $REPO

printf "\nBuilding AUR Packages\n"
echo "====================="

# git clone linux-bcachefs-git
# git clone https://aur.archlinux.org/bcachefs-tools-git.git
# git clone https://aur.archlinux.org/linux-bcachefs-git.git

function add_aur {
    CURRDIR=$(pwd)
    URL=$1
    INSTALL=$2
    NAME=$(echo $URL | sed -r 's/^.*\.org\/(.*).git$/\1/')

    cd $PACKAGE_DIR
    shopt -s nullglob

    BUILT=( $NAME/*.pkg.* )
    if (( ${#BUILT[@]} )); then
        echo "$NAME already built!"
        cd $NAME
    else
        echo "Building $NAME"
        echo "=============="

        rm -rf $NAME
        git clone $URL
        cd $NAME
        makepkg -sc
    fi

    if [ "$INSTALL" = true ]; then
        sudo pacman -U *.pkg.* --noconfirm --needed
    fi

    repo-add $REPO *.pkg.*
    cp *.pkg.* $REPO_DIR

    # restore
    cd $CURRDIR
    shopt -u nullglob
}

add_aur https://aur.archlinux.org/libscrypt-git.git true
add_aur https://aur.archlinux.org/bcachefs-tools-git.git
add_aur https://aur.archlinux.org/linux-bcachefs-git.git


printf "\nBuilding the ISO\n"
echo "====================="

sudo cp -r $PACKAGE_DIR $WORKDIR/airootfs
cd $WORKDIR
sudo ./build.sh -v
