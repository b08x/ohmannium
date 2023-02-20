#!/usr/bin/env bash

declare -rx timestampe=$(date +%Y%m%d%H%M)

#########################################################################
#                             set colors                                 #
#########################################################################

declare -rx ALL_OFF="\e[1;0m"
# declare -rx BOLD="\e[1;1m"
declare -rx BLUE="${BOLD}\e[1;34m"
declare -rx GREEN="${BOLD}\e[1;32m"
declare -rx RED="${BOLD}\e[1;31m"
declare -rx YELLOW="${BOLD}\e[1;33m"

say () {
  local statement=$1
  local color=$2

  echo -e "${color}${statement}${ALL_OFF}"
}

#########################################################################
#                             set locations                             #
#########################################################################

declare -rx AUR_BUILDER_HOME="/home/aur_builder"

declare -rx PACKAGES="${AUR_BUILDER_HOME}/Packages"
declare -rx REPOSITORY_LOCAL="${AUR_BUILDER_HOME}/Repository"

declare -rx REPOSITORY_REMOTE="ec2-user@soundbot.hopto.org"

declare -rx WORKSPACE="${AUR_BUILDER_HOME}/Workspace"
declare -rx PKGBUILDS="${WORKSPACE}/pkgbuilds"


#########################################################################
#                             Greetings                                 #
#########################################################################

gum style \
  --foreground 014 --border-foreground 024 --border double \
  --align center --width 50 --margin "1 2" --padding "2 4" \
  'Hello.' && sleep 1 && clear

#########################################################################

say "Select cpu architecture" $GREEN
say "------------------------" $GREEN

architecture=$(gum choose --limit=1 "x86_64" "x86_64_v3")

say "${architecture}" $BLUE

pacman="${WORKSPACE}/devtools/pacman-${architecture}.conf"
makepkg="${WORKSPACE}/devtools/makepkg-${architecture}.conf"

say $pacman $BLUE
say $makepkg $BLUE

#########################################################################

#declare -a package_list=$(fd -t d --max-depth 1 --relative-path --search-path $PKGBUILDS -x echo "{/}")

declare -a package_list=$(exa -D -1 -s modified $PKGBUILDS)

say "select packages to build" $GREEN
say "-------------------------" $GREEN
package_selection=$(gum choose --no-limit --height 30 all ${package_list[@]})

if [[ $package_selection == 'all' ]]; then
  package_selection=${package_list[@]}
fi

say "${package_selection}" $BLUE

#########################################################################

declare -rx CHROOT="/mnt/chroots/arch"

unmount_chroot() {
  if mountpoint -q $CHROOT; then sudo umount $CHROOT; fi
}

mount_chroot() {
  unmount_chroot
  sudo mount --mkdir -t tmpfs -o defaults,size=8G tmpfs $CHROOT
}

create_chroot() {
  if [ -L $AUR_BUILDER_HOME/.makepkg.conf ]; then
    ln -sf $makepkg $AUR_BUILDER_HOME/.makepkg.conf
  else
    rm -rf $AUR_BUILDER_HOME/.makepkg.conf || exit
    ln -s $makepkg $AUR_BUILDER_HOME/.makepkg.conf
  fi

  mkarchroot -C $pacman -M $makepkg -f /etc/pacman.d/cachyos-mirrorlist \
  -f /etc/pacman.d/cachyos-v3-mirrorlist $CHROOT/root base-devel
}

update_chroot() {
  if [[ $architecture == 'x86_64_v3' ]]; then
    arch-nspawn -C $pacman -M $makepkg $CHROOT/root pacman-key --recv-keys F3B607488DB35A47 --keyserver keyserver.ubuntu.com

    sudo arch-nspawn -C $pacman -M $makepkg $CHROOT/root pacman-key --lsign-key F3B607488DB35A47

    local mirror_url="https://mirror.cachyos.org/repo/x86_64/cachyos"

    arch-nspawn -C $pacman -M $makepkg $CHROOT/root yes | sudo pacman -U --noconfirm "${mirror_url}/cachyos-keyring-2-1-any.pkg.tar.zst" \
    "${mirror_url}/cachyos-mirrorlist-15-1-any.pkg.tar.zst" \
    "${mirror_url}/cachyos-v3-mirrorlist-15-1-any.pkg.tar.zst" \
    "${mirror_url}/cachyos-v4-mirrorlist-3-1-any.pkg.tar.zst" \
    "${mirror_url}/pacman-6.0.2-10-x86_64.pkg.tar.zst"
  else
    sudo arch-nspawn -C $pacman -M $makepkg $CHROOT/root pacman -Syu
  fi
}

build () {
  local pkgname=$1
  cd ${PKGBUILDS}/${pkgname}
  echo ${timestampe} > .latest-build
  makechrootpkg -n -c -r $CHROOT
}

#########################################################################

cleanup() {
	local s="${PACKAGES}/${architecture}/sources/$pkg*"
	echo $s
}

trap cleanup SIGINT SIGTERM ERR EXIT

if [ $? == 0 ]
then
  mount_chroot
  create_chroot
  update_chroot

  for name in ${package_selection[@]}; do
    declare -x pkg=$name
    build $pkg || break
  done

  rm $AUR_BUILDER_HOME/.makepkg.conf
  unmount_chroot
else
  echo -e "${RED}alright. exiting for now...${ALL_OFF}"
  exit
fi

# end of program
