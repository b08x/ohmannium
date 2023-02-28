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

#########################################################################

wipe="true"

if [[ $wipe == 'true' ]]; then wipe && sleep 1; fi
say "-------------------\n" $GREEN

declare -rx WORKSPACE="${HOME}/Workspace"

if [ ! -d $WORKSPACE ]; then mkdir -pv $WORKSPACE; fi

declare -rx ANSIBLE_HOME="${WORKSPACE}/ohmannium"
declare -rx PLAYBOOKS="${ANSIBLE_HOME}/playbooks"
declare -rx INVENTORY="${PLAYBOOKS}/inventory.yml"

#########################################################################

if [ ! -d $ANSIBLE_HOME ]; then
  say "------------------\n" $GREEN
  say "project will be cloned to ${ANSIBLE_HOME}" $BLUE
  clone https://gitlab.com/b08x/ohmannium.git $ANSIBLE_HOME
  cd $ANSIBLE_HOME
else
  cd $ANSIBLE_HOME
fi

git checkout release/ohmannium && git fetch && git pull

git lfs install && git lfs checkout && git lfs fetch && git lfs pull

sleep 1 && chown -R $USER $WORKSPACE

#########################################################################

if [[ $wipe == 'true' ]]; then wipe && sleep 1; fi
say "-------------------------" $YELLOW

gum confirm "copy ssh keys from a remote host?" && say "ok" $GREEN

if [ $? = '0' ]; then
  say "Enter the fqdn or ip of the remote host" $GREEN

  read KEYSERVER

  say "setting ${KEYSERVER} as remote host keyserver\n"

else
  KEYSERVER=""
fi

#########################################################################

if [[ $wipe == 'true' ]]; then wipe && sleep 1; fi
say "-------------------------\n" $YELLOW
say "select playbook to run" $GREEN

playbooks=$(gum choose --no-limit "ohmannium" "base" "ui" "nas" )

runas_user=$(gum choose $USER)

say "\nrunning ${playbooks} playbook as ${runas_user}\n" $BLUE
sleep 1

#######################################################################################
# if any host has ansible_connection set to local (usually ninjabot), set to ssh
sed -i 's/      ansible_connection: local/      ansible_connection: ssh/' $INVENTORY

# set global ansible_connection to local
sed -i 's/    ansible_connection: ssh/    ansible_connection: local/' $INVENTORY
########################################################################################

for playbook in ${playbooks[@]}; do
  ansible-playbook -K -i $INVENTORY "${PLAYBOOKS}/${playbook}.yml" \
                   --limit $(uname -n) \
                   -e "newInstall=true" \
                   -e "update_mirrors=true" \
                   -e "cleanup=true" \
                   -e "keyserver=${KEYSERVER}"
done

#########################################################################

if [[ $wipe == 'true' ]]; then wipe && sleep 2; fi

if command -v yadm &>/dev/null; then
  gum confirm --selected.background="#ddb31f" --default=yes "clone a dots repository?"

  if [ $? = 0 ]; then
    echo "enter repository address"
    dotsrepo=$(gum input --placeholder "git@github.com:<user>/dots.git")

    cd $HOME && yadm clone $dotsrepo

  else
    echo "ok then. we're all set"
  fi
else
  echo "it appears that yadm is not installed..."
fi

#########################################################################

if [[ $wipe == 'true' ]]; then wipe && sleep 1; fi

say "bootstrap complete\!" $GREEN

if [[ $wipe == 'true' ]]; then wipe && sleep 2; fi

say "rebooting in 10 seconds...exit CTRL+C to cancel" $RED && sleep 10

sudo shutdown -r now
