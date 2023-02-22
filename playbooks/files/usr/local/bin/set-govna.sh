#!/usr/bin/env bash

set_govna () {
  # sudo cpupower frequency-set -r -g "$1"
  echo "$1" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
}

action=$(whiptail --title "Menu example" --menu "Choose an option" 15 42 5 \
"performance" "Select performance profile" \
"powersave" "Select powersave profile" 3>&1 1>&2 2>&3)

set_govna $action

sleep 0.5

exit
