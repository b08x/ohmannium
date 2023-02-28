#!/usr/bin/env bash
set -e

# PS4='LINENO:'
VER=0.5-beta

ctrl_c() {
        echo "** Exiting the program. The end."
        sleep 1
}

trap ctrl_c INT SIGINT SIGTERM ERR EXIT

tput reset

if [[ "${EUID}" -eq 0 ]]; then
  echo "please run with sudo. exiting"
  exit
fi

export PATH+=":/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

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

#########################################################################
#                        install dependencies                           #
#########################################################################

BOOTSTRAP_PKGS=(
  'ansible'
  'aria2'
  'base-devel'
  'bc'
  'ccache'
  'cmake'
  'fd'
  'dialog'
  'git'
  'git-lfs'
  'gum'
  'htop'
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

say "hello\n" $GREEN

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

# configure ruby to install gems as root and without docs
echo "gem: --no-user-install --no-document" | sudo tee /etc/gemrc

GEMS=(
  'colorize'
  'logging'
  'ruport'
  'tty-command'
  'yaml'
)

for gem in "${GEMS[@]}"; do
  sudo gem install "$gem" || continue
done

# install oh-my-zsh
if [ -d "/usr/local/share/oh-my-zsh" ]; then
  echo "oh-my-zsh already installed"
else
  cd /tmp
  git clone --recursive https://github.com/ohmyzsh/ohmyzsh.git
  sudo env ZSH="/usr/local/share/oh-my-zsh" /tmp/ohmyzsh/tools/install.sh --unattended
fi

#########################################################################
wipe="false"
if [[ $wipe == 'true' ]]; then wipe && sleep 1; fi

say "-------------------\n" $GREEN

declare -rx user=$(getent passwd | grep 1000 | awk -F ":" '{print $1}' | xargs)

say "\nuid 1000 is assigned to ${user}\n" $YELLOW

declare -rx WORKSPACE="/home/${user}/Workspace"

if [ ! -d $WORKSPACE ]; then mkdir -pv $WORKSPACE; fi

declare -rx ANSIBLE_HOME="$WORKSPACE/syncopated"

#########################################################################

if [ ! -d $ANSIBLE_HOME ]; then
  say "------------------\n" $GREEN
  say "project will be cloned to ${ANSIBLE_HOME}" $BLUE
  clone https://gitlab.com/b08x/syncopated.git $ANSIBLE_HOME
  cd $ANSIBLE_HOME
else
  cd $ANSIBLE_HOME
fi

git checkout release/ohmannium && git fetch && git pull

git lfs install && git lfs checkout && git lfs fetch && git lfs pull

sleep 1 && chown -R ${user} $WORKSPACE

if [[ $wipe == 'true' ]]; then wipe && sleep 1; fi
say "-------------------------" $YELLOW

say "select playbook to run" $GREEN
say "-------------------------\n" $YELLOW

playbooks=$(gum choose --no-limit "syncopated" "base" "ui" "nas" )

runas_user=$(gum choose $user)

gum confirm "copy ssh keys from a remote host?" && say "ok" $GREEN

if [ $? = '0' ]; then
  say "Enter the fqdn or ip of the remote host" $GREEN

  read KEYSERVER

  say "setting ${KEYSERVER} as remote host keyserver\n"

else
  KEYSERVER=""
fi

if [[ $wipe == 'true' ]]; then wipe && sleep 1; fi

say "\nrunning ${playbooks} playbook as ${runas_user}\n" $BLUE

for playbook in ${playbooks[@]}; do
  ansible-playbook -K -i "${ANSIBLE_HOME}/playbooks/inventory.yml" "${ANSIBLE_HOME}/playbooks/${playbook}.yml" \
                   --limit $(uname -n) \
                   -e "newInstall=true" \
                   -e "update_mirrors=true" \
                   -e "cleanup=true" \
                   -e "keyserver=${KEYSERVER}"
done

if [[ $wipe == 'true' ]]; then wipe && sleep 1; fi

say "bootstrap complete\!" $GREEN && sleep 2
