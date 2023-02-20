#!/usr/bin/env bash

if [[ ! "${EUID}" -eq 0 ]]; then
  echo "please run as root. exiting"
  exit
fi

if [ $(command -v fd) ];then
  mkdir -pv /tmp/removed

  fd -E '*.gnupg' -E 'pubring' -E 'run/' -E 'mnt/' -H "@\d+:\d+:\d+~$" \
     --full-path '/' -X mv -v '{}' /tmp/removed/

  echo "the ansible backup files moved to /tmp/removed and will be removed upon next reboot"

else
  echo "fd is not installed. "
fi
