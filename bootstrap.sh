#!/usr/bin/env sh
set -ex

# PS4='LINENO:'
VER=0.5-beta

ctrl_c() {
        echo "** Exiting the program. The end."
        sleep 1
}

trap ctrl_c INT SIGINT SIGTERM ERR EXIT

tput reset

if [[ ! "${EUID}" -eq 0 ]]; then
  echo "please run as root. exiting"
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

# install repository keys
if [[ ! -z "$(pacman-key --list-keys | grep syncopated 2>/dev/null)" ]];
then
  printf "key already installed"
else
  printf "adding syncopated gpg to pacman db"
  sleep 0.5
  curl http://soundbot.hopto.org/syncopated.gpg | pacman-key --add -
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

# install oh-my-zsh
if [ -d "/usr/local/share/oh-my-zsh" ]; then
  echo "oh-my-zsh already installed"
else
  cd /tmp
  git clone --recursive https://github.com/ohmyzsh/ohmyzsh.git
  env ZSH="/usr/local/share/oh-my-zsh" /tmp/ohmyzsh/tools/install.sh --unattended
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

say "------------------\n" $GREEN
say "project will be cloned to ${ANSIBLE_HOME}" $BLUE


#########################################################################

if [ ! -d $ANSIBLE_HOME ]; then
  clone https://github.com/b08x/syncopated.git $ANSIBLE_HOME
  cd $ANSIBLE_HOME && git restore .
else
  cd $ANSIBLE_HOME
fi

echo "---" > inventory.yml
echo "\n" >> inventory.yml
echo "all:" >> inventory.yml
echo "  hosts:" >> inventory.yml
echo "    $(uname -n):" >> inventory.yml
echo "      ansible_connection: local" >> inventory.yml

sleep 1 && chown -R ${user} $WORKSPACE

if [[ $wipe == 'true' ]]; then wipe && sleep 1; fi
say "-------------------------" $YELLOW

say "select playbook to run" $GREEN
say "-------------------------\n" $YELLOW

playbooks=$(gum choose --no-limit "base" "ui" "nas" "builder")
runas_user=$(gum choose $user aur_builder)

gum confirm "copy ssh keys from remote host?"

if [ $? = 0 ]; then
  say "Enter the hostname\n" $GREEN
  keyserver=$(gum input --placeholder="host.example.net")
else
  keyserver="na"
fi

if [[ $wipe == 'true' ]]; then wipe && sleep 1; fi

say "\nrunning ${playbooks} playbook as ${runas_user}\n" $BLUE

for playbook in ${playbooks[@]}; do
  ansible-playbook -c local -i $(uname -n), "${ANSIBLE_HOME}/playbooks/${playbook}.yml" \
                   -e "newInstall=true" \
                   -e "cleanup=true" \
                   -e "keyserver=${keyserver}"
done

if [[ $wipe == 'true' ]]; then wipe && sleep 1; fi

say "bootstrap complete\!" $GREEN && sleep 2
