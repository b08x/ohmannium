#!/usr/bin/env bash
set -x
PS4='LINENO:'
VER=0.5-beta

export PATH+=":/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

BOOTSTRAP_PKGS=(
  'ansible'
  'base-devel'
  'ccache'
  'cmake'
  'git'
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
  'whiptail'
  'wget'
  'zsh'
)

function startssh() {
  systemctl enable sshd.service

  systemctl start sshd.servce || echo "unable to start sshd"
}

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

startssh

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
echo "----------\n"

printf "confirm userid"
ANSIBLE_USER=$(gum input --placeholder="enter userid if different" --value=$(getent passwd | grep 1000 | awk -F ":" '{print $1}'))

printf "enter location to clone repository:"
ANSIBLE_HOME=$(gum input --placeholder"enter location to clone" --value="/home/$user/Workspace")

echo "----------\n"

# NAME=$(whiptail --inputbox "What is your name?" 8 39 --title "Getting to know you" 3>&1 1>&2 2>&3)

declare -rx ANSIBLE_PLUGINS="$ANSIBLE_HOME/plugins/modules"
declare -rx ANSIBLE_CONFIG="$ANSIBLE_HOME/ansible.cfg"
declare -rx ANSIBLE_INVENTORY="$ANSIBLE_HOME/inventory.ini"

# if this is an initial install; clone repository then run playbook
# otherwise, change into $ANSIBLE_HOME and run git status
if [ ! -d $ANSIBLE_HOME ]; then
  git clone --recursive https://github.com/SyncopatedStudio/cm.git $ANSIBLE_HOME
  git config --global --add safe.directory $ANSIBLE_HOME

  chown -R $user:$user $ANSIBLE_HOME

  cd $ANSIBLE_HOME
  git restore . && git checkout development

  echo "$(uname -n) ansible_connection=local" > $ANSIBLE_INVENTORY

  ansible-playbook --connection=local -i $(uname -n), syncopated.yml

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
