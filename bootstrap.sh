#!/usr/bin/env bash
set -e

# PS4='LINENO:'
VER=0.5-beta

ctrl_c() {
        echo "** End."
        sleep 1
}

trap ctrl_c INT SIGINT SIGTERM ERR EXIT

tput reset

if [[ "${EUID}" -eq 0 ]]; then
  echo "please run with sudo. exiting"
  exit
fi

declare -rx dotsrepo="git@github.com:b08x/dots.git"

#########################################################################
#                             set colors                                #
#########################################################################

declare -rx ALL_OFF="\e[1;0m"
declare -rx BBOLD="\e[1;1m"
declare -rx BLUE="${BOLD}\e[1;34m"
declare -rx GREEN="${BOLD}\e[1;32m"
declare -rx RED="${BOLD}\e[1;31m"
declare -rx YELLOW="${BOLD}\e[1;33m"

#########################################################################
#                             functions                                 #
#########################################################################

say () {
  local statement=$1
  local color=$2

  echo -e "${color}${statement}${ALL_OFF}"
}

clone () {
  local repo=$1
  local dest=$2
  git clone --recursive $repo $dest
  git config --global --add safe.directory $dest
}

wipe() {
tput -S <<!
clear
cup 20
!
}

wipe="true"

#########################################################################
#                        install dependencies                           #
#########################################################################

BOOTSTRAP_PKGS=(
  'ansible'
  'aria2'
  'base-devel'
  'bat'
  'bc'
  'ccache'
  'cmake'
  'fd'
  'dialog'
  'git'
  'git-lfs'
  'gum'
  'htop'
  'lnav'
  'neovim'
  'net-tools'
  'openssh'
  'python-pip'
  'reflector'
  'ruby-bundler'
  'rubygems'
  'rust'
  'unzip'
  'wget'
  'zsh'
)

say "hello.\n" $GREEN

# clean cache
sudo pacman -Scc --noconfirm > /dev/null

# install repository keys
if [[ ! -z "$(pacman-key --list-keys | grep syncopated 2>/dev/null)" ]];
then
  printf "key already installed"
else
  printf "adding syncopated gpg to pacman db"
  sleep 0.5
  curl -s http://soundbot.hopto.org/syncopated.gpg | sudo pacman-key --add -
  sudo pacman-key --lsign-key 36A6ECD355DB42B296C0CEE2157CA2FC56ECC96A > /dev/null
  sudo pacman -Sy --noconfirm > /dev/null
fi

if [[ ! -z "$(pacman-key --list-keys | grep proaudio 2>/dev/null)" ]];
then
  printf "key already installed"
else
  printf "adding OSAMC gpg to pacman db"
  sleep 0.5
  curl -s https://arch.osamc.de/proaudio/osamc.gpg | sudo pacman-key --add -
  sudo pacman-key --lsign-key 762AE5DB2B38786364BD81C4B9141BCC62D38EE5 > /dev/null
  sudo pacman -Sy --noconfirm > /dev/null
fi

# install pre-requisite packages
sudo pacman -Sy --noconfirm --needed "${BOOTSTRAP_PKGS[@]}"

# install oh-my-zsh
if [ -d "/usr/local/share/oh-my-zsh" ]; then
  echo "oh-my-zsh already installed"
else
  cd /tmp
  git clone --recursive https://github.com/ohmyzsh/ohmyzsh.git
  sudo env ZSH="/usr/local/share/oh-my-zsh" /tmp/ohmyzsh/tools/install.sh --unattended
fi

sudo curl -fLo /usr/local/bin/yadm https://github.com/TheLocehiliosan/yadm/raw/master/yadm
sudo chmod a+x /usr/local/bin/yadm

export PATH+=":/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

if [[ $wipe == 'true' ]]; then wipe && sleep 1; fi
say "-------------------------------------------" $YELLOW

gum confirm "copy ssh keys from a remote host?" && say "ok" $GREEN

if [ $? = '0' ]; then
  say "Enter the fqdn or ip of the remote host" $GREEN

  read -e KEYSERVER

  say "setting ${KEYSERVER} as remote host keyserver\n"

  rsync -avP $KEYSERVER:~/.ssh $HOME/

  if [ ! $? = 0 ]; then
    say "key copy failed....do something about it."
    exit
  fi
else
  say "ok then" $RED
fi

if [ ! $HOME/.local/share/yadm/repo.git ]; then
  cd $HOME && yadm clone $dotsrepo
else
  cd $HOME && yadm fetch && yadm pull
  yadm bootstrap
fi
