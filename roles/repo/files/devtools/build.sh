#!/usr/bin/env bash

declare -rx PACKAGES="${HOME}/Packages"
declare -rx REPOSITORY_LOCAL="${HOME}/Repository"
declare -rx REPOSITORY_REMOTE="ec2-user@soundbot.hopto.org"

declare -rx WORKSPACE="${HOME}/Workspace"
declare -rx PKGBUILDS="${WORKSPACE}/pkgbuilds"

declare -rx CHROOT="${WORKSPACE}/chroot"

# set colors
declare -rx ALL_OFF="\e[1;0m"
# declare -rx BOLD="\e[1;1m"
declare -rx BLUE="${BOLD}\e[1;34m"
declare -rx GREEN="${BOLD}\e[1;32m"
declare -rx RED="${BOLD}\e[1;31m"
declare -rx YELLOW="${BOLD}\e[1;33m"

# obtain package list from folder names in pkgbuild directory
declare -a package_list=$(fd -t d --max-depth 1 --relative-path --search-path $PKGBUILDS -x echo "{/}")

echo $package_list

say () {
  local statement=$1
  local color=$2

  echo -e "${color}${statement}${ALL_OFF}"
}

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

say "select packages to build" $GREEN
say "-------------------------" $GREEN
package_selection=$(gum choose --no-limit --height 30 all ${package_list[@]})

if [ $package_selection == 'all' ]; then
  package_selection=${package_list[@]}
fi

say "${package_selection}" $BLUE

#########################################################################

create_chroot() {
  if [ -L ~/.makepkg.conf ]; then
    ln -sf $makepkg ~/.makepkg.conf
  else
    rm -rf ~/.makepkg.conf || exit
    ln -s $makepkg ~/.makepkg.conf
  fi

  sudo rm -rf $CHROOT && mkdir -pv $CHROOT

  mkarchroot -C $pacman -M $makepkg -f /etc/pacman.d/cachyos-mirrorlist \
  -f /etc/pacman.d/cachyos-v3-mirrorlist $CHROOT/root base-devel
}

update_chroot() {
  arch-nspawn -C $pacman -M $makepkg $CHROOT/root pacman -Syu
}

build () {
  local pkgname=$1
  cd ${PKGBUILDS}/${pkgname}
  makechrootpkg -n -c -r $CHROOT
}

#########################################################################

if [ $? == 0 ]
then
  create_chroot
  update_chroot
  for name in ${package_selection[@]}; do
    build $name || exit
  done
  rm ~/.makepkg.conf
else
  echo -e "${RED}alright. exiting for now...${ALL_OFF}"
  exit
fi

# end of program
