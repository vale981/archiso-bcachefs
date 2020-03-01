# Archlinux Live with Bcachefs

The scripts in this repo can be used to obtain an `Arch Linux`
live/install/rescue ISO. This is realized through
[Archiso](https://wiki.archlinux.org/index.php/Archiso) with some
hacks to make it use the `linux-bcachefs-git` [from the
AUR](https://aur.archlinux.org/packages/linux-bcachefs-git/).

The whole thing is currently in a *works for me* kind of state.

## Usage
I recommend that you at least skim the scripts in this repo to understand what is happening, because they require `root` access. You can either build the iso directly on arch, or use docker to provide an arch environment.

* The script will build the linux bcachefs kernel from the AUR and you
     set the architecture to build the kernel interactively, whenever
     the prompt comes up. I will add a variable to the `make_iso.sh`
     script when I come around to it...
* In the end, the ISO can be found under `archlive/out`

### On Arch Linux
 * make sure you have the following installed: `archiso sudo git base-devel bash`
   <!-- * or set the `KERNEL_ARCH` variable in the `make_iso.sh` script -->
 * run `./make_iso.sh` and get a cup of whatever hot beverage you favor


### Through Docker
> I have not tested this yet.

 * make sure you have `docker` installed
 * run `./docker-setup.sh`
   * This will create an ephemeral, **privileged** docker container to
     provide an arch environment and run `./make_iso.sh`