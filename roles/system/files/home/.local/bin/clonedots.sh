#!/usr/bin/env bash

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
