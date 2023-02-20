#!/usr/bin/env bash

tput reset

if [[ ! "${EUID}" -eq 0 ]]; then
  echo "please run as root. exiting"
  exit
fi

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


PS4='LINENO:'
VER=0.5-beta

export PATH+=":/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

BOOTSTRAP_PKGS=(
  'ansible'
  'base-devel'
  'ccache'
  'cmake'
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
  'wget'
  'zsh'
)

if [[ ! -z "$(pacman-key --list-keys | grep syncopated 2>/dev/null)" ]];
then
  printf "key already installed"
else
  printf "adding syncopated gpg to pacman db"
  sleep 0.5
  curl http://soundbot.hopto.org/syncopated/syncopated.gpg | pacman-key --add -
  pacman-key --lsign-key 36A6ECD355DB42B296C0CEE2157CA2FC56ECC96A
  pacman -Sy --noconfirm
fi

if [[ ! -z "$(pacman-key --list-keys | grep proaudio 2>/dev/null)" ]];
then
  printf "key already installed"
else
  printf "adding OSAMC gpg to pacman db"
  sleep 0.5
  curl https://arch.osamc.de/proaudio/osamc.gpg | pacman-key --add -
  pacman-key --lsign-key 762AE5DB2B38786364BD81C4B9141BCC62D38EE5
  pacman -Sy --noconfirm
fi

# clean cache
pacman -Scc --noconfirm

# install pre-requisite packages
pacman -Sy --noconfirm --needed "${BOOTSTRAP_PKGS[@]}"

systemctl enable sshd.service

# install oh-my-zsh
if [ -d "/usr/local/share/oh-my-zsh" ]; then
  echo "oh-my-zsh already installed"
else
  cd /tmp || exit
  git clone --recursive https://github.com/ohmyzsh/ohmyzsh.git
  env ZSH="/usr/local/share/oh-my-zsh" /tmp/ohmyzsh/tools/install.sh --unattended
fi

# [[ $LINES ]] || LINES=$(tput lines)
# [[ $COLUMNS ]] || COLUMNS=$(tput cols)
echo -e "----------\n"

function getuserid() {
  user=$(getent passwd | grep 1000 | awk -F ":" '{print $1}')
}

getuserid

declare -rx WORKSPACE="/home/$user/Workspace"

if [ ! -d $WORKSPACE ]; then mkdir -pv $WORKSPACE; fi

declare -rx ANSIBLE_HOME="$WORKSPACE/syncopated"

#
# printf "confirm userid"
# ANSIBLE_USER=$(gum input --placeholder="enter userid if different" --value="b08x")
#
# printf "enter location to clone repository:"
# ANSIBLE_HOME=$(gum input --placeholder"enter location to clone" --value="/home/$user/Workspace")
#
# echo -e "----------\n"

# NAME=$(whiptail --inputbox "What is your name?" 8 39 --title "Getting to know you" 3>&1 1>&2 2>&3)

declare -rx ANSIBLE_INVENTORY="$ANSIBLE_HOME/inventory.yml"

declare -a ANSIBLE_PLAYBOOKS=$(/usr/bin/ls $ANSIBLE_HOME/playbooks/)

say "select playbook to run" $GREEN
say "-------------------------" $GREEN

playbook=$(gum choose ${ANSIBLE_PLAYBOOKS[@]})

say "running ${playbook}" $BLUE

# if this is an initial install; clone repository then run playbook
# otherwise, change into $ANSIBLE_HOME and run git status
if [ ! -d $ANSIBLE_HOME ]; then
  git clone --recursive https://github.com/b08x/syncopated.git $ANSIBLE_HOME
  git config --global --add safe.directory $ANSIBLE_HOME

  cd $ANSIBLE_HOME
  git restore . && git checkout development
  git lfs install || exit
  git lfs checkout && git lfs fetch || exit

  echo "---" > inventory.yml
  echo "\n" >> inventory.yml
  echo "all:" >> inventory.yml
  echo "  hosts:" >> inventory.yml
  echo "    $(uname -n):" >> inventory.yml
  echo "      ansible_connection: local" >> inventory.yml

  chown -R $user:$user $ANSIBLE_HOME

  ansible-playbook --connection=local -i $(uname -n), "${ANSIBLE_PLAYBOOKS}/${playbook}" -e "newInstall=true"

  if [ $? = 0 ]; then
    echo "ansible bootstrap complete!"
    sleep 3
  else
    echo "woeful errors have occured at some point in this process."
  fi

else
  printf "somehow $ANSIBLE_HOME already exists...."
  sleep 1
  exit
fi
