#!/usr/bin/env bash
set -e

say () {
  local statement=$1
  local color=$2

  echo -e "${color}${statement}${ALL_OFF}"
}

say "Select cpu architecture" $GREEN
say "------------------------" $GREEN

architecture=$(gum choose --limit=1 "x86_64" "x86_64_v3")

declare -rx WORKSPACE="/home/aur_builder/Workspace"
declare -rx PACKAGES="/home/aur_builder/Packages/${architecture}"
declare -rx DEBUGPKGS="${PACKAGES}/debug/${architecture}"

declare -rx LOCAL_REPO="/home/aur_builder/Repository/${architecture}"
declare -rx REMOTE_REPO="ec2-user@soundbot.hopto.org"

cd $PACKAGES

fd --exact-depth 1 -t f "debug" -x mv {} $DEBUGPKGS

echo "select package(s) to move into the repository"
echo "press CTRL+C to select nothing"
sleep 1

new_packages=$(fd -e .zst -E 'debug/' -a)

if [[ -z "$new_packages" ]]; then
  echo "no new packages"
else
  selected=$(${new_packages} | gum filter --no-limit | xargs echo)
  echo "moving new packages to repository"
  for pkg in ${new_packages[@]}; do
    mv -v $pkg "${LOCAL_REPO}/"
  done
fi

cd $LOCAL_REPO

phrase=$(gum input --password)

echo "signing packages"
for pkg in *.zst; do
  echo "$phrase" | gpg2 -v --batch --yes --detach-sign --pinentry-mode loopback --passphrase --passphrase-fd 0 --out ${LOCAL_REPO}/$pkg.sig --sign $pkg
done

echo "refreshing repository database"
repo-add -v -n -k 36A6ECD355DB42B296C0CEE2157CA2FC56ECC96A syncopated.db.tar.gz *.pkg.tar.zst -s

echo "syncing local repository to remote mirror"
if [ $? = 0 ]; then
  gum confirm "push to remote repository?" && \
  rsync -avP --delete  "${LOCAL_REPO}/" "${REMOTE_REPO}:/usr/share/nginx/html/syncopated/${architecture}/"
else
  echo "something went horribily wrong with refreshing the repository. we have to evacuate"
fi
