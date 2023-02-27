# syncopated

An exercise in configuration management.

# Install

At current this is being used with [ArchLabs](https://archlabslinux.com/) however this was designed to accommodate most major distributions with minimal alteration.

```bash
$ bash <(curl -s http://soundbot.hopto.org/bootstrap.sh)
```

[insert screencast]


# Variables

Depending on the use-case, variables can be set in several different files.

Variables can be set in [inventory.yml](playbooks/inventory.yml)

Set variables that can applied all hosts under
`all:
  vars:
`

```yaml
all:
  vars:
    ansible_user: b08x
    tray_output: "primary"
    workspaces:
      - "$ws1 output primary"
      - "$ws2 output primary"
      - "$ws3 output primary"
      - "$ws4 output primary"
      - "$ws5 output primary"
      - "$ws6 output primary"
      - "$ws7 output primary"
      - "$ws8 output primary"
      - "$ws9 output primary"
      - "$ws10 output primary"
  hosts:
    ninjabot:
      ...
```

Variables set in the inventory file can also be set per host.

Variables set for a host will override those set for all.

```yaml
  hosts:
    ninjabot:
      ansible_connection: local
      tray_output: "HDMI1"
      workspaces:
        - "$ws1 output HDMI1"
        - "$ws2 output HDMI1"
        - "$ws3 output HDMI1"
        - "$ws4 output HDMI2"
        - "$ws5 output HDMI2"
        - "$ws6 output HDMI2"
        - "$ws7 output HDMI2"
        - "$ws8 output HDMI2"
        - "$ws9 output HDMI2"
        - "$ws10 output HDMI2"
```

Variables can also be set within files located in the [vars/](playbooks/vars/) directory then included either in a playbook or task file. Variables set within a playbook or task will override variables set in inventory.



# Usage

## all tasks
<details>
  <summary>`ansible-playbook -C -i inventory.yml syncopated.yml --list-tasks`</summary>


```yaml
playbook: syncopated.yml

  play #1 (all): all
    tasks:
      include distro vars
      include user vars
      set ansible_home
      print keyserver hostname
      check if keys are present
      copy keys from remote host
      enable ssh daemon
      set admin_group variable
      add user to groups defined in playbook
      disable requiretty for user so automation can run without interruption
      ensure /etc/sudoers.d exists
      set NOPASSWD for user in sudoers
      set NOPASSWD for user in polkit
      remove existing sudoers if there is one
      check -march support
      check output from grep command
      set architecture
      set architecture
      debug

  play #2 (all): setup repositories and install packages
    tasks:
      add syncopated repo key
      add archaudio repo key
      adjust pacman, paru and makepkg configs
      update cache
      check if paru installed
      install paru
      check if mirrors have been updated within the past 24h
      print output
      update mirrors
      update and upgrade
      remove pipewire
      include package vars
      prepare pacage list
      print package list
      install packages
      print results

  play #3 (all): all
    tasks:
      symlink os-release
      install systemd configs
      set system log level config
      set user log level config
      reload systemd
      set root shell
      sync zsh functions
      ensure /usr/local/share/zsh has correct owner/group
      create group for user
      set user primary group
      ensure user ownership of home directory
      install yadm
      copy clonedots script into user home
      copy ld config file
      run ldconfig
      starting network tasks
      disable systemd-networkd service
      ensure networkmanager connection check is enabled
      enable and start networkmanager
      set ntp servers in timesyncd.conf
      set autofs config folder
      create mount directory folder if it doesn't already exist
      install autofs configs
      starting audio role tasks
      add modprobe for alsa card order
      ensure user belongs to audio group
      ensure /etc/security/limits.d directory exists
      install jack limits file
      install timer permissions file
      set vm.swappiness to 10 to ensure swap isn't overly used
      set vm.dirty_background_bytes to 100000000
      set fs.inotify.max_user_watches
      set dev.hpet.max-user-freq=3072
      enable tuned service
      create tuned profile folder
      install realtime-modified profile
      install rtirq defaults
      install rtkit.conf
      install rtkit systemd file
      install cpucpower defaults
      enable cpupower service
      disable irqbalance service
      create environment file for jack_control.service
      install jack_control service file
      ensure pulse config directory exists
      update pulseaudio configs
      ensure /etc/pulse/default.pa.d exists
      install pulseaudio bluetooth config
      adjust pulseaudio.service file
      enable and start firewalld
      permit traffic to common services
      permit traffic to jacktrip, barrier and qmidinet
      check if the btrfs filesystem is being used
      install btrfsmaintenance
      Enable zstd compression in mkinitcpio
      Rebuild ramdisk environment if a change was made.
      enable and/or start btrfs-scrub@-.timer
      check if fstrim will be necessary
      debug
      ensure fstrim.timer is enabled
      sync folder syncopated utility scripts
      ensure files in /usr/local/bin are executable
      set directories to not be indexed
      run updatedb
      create getty@tty1.service.d directory
      create systemd drop-in file for virtual console autologin
      install lightdm
      ensure group autologin exists
      add user to autologin group
      install xsession file to /etc/lightdm/xsession
      update lightdm.conf
      update pam
      set dmrc to i3
      install modified starfield theme
      set kernel cmdline params in grub
      remake grub if changes were made
      remake grub if changes were made
      reboot host if grub was modified
      wait for host to reboot
      reboot host
      wait for host to reboot

  play #4 (all): configure user specific stuff
    tasks:
      include vars
      include user vars
      ensure usr local directories exist
      install input-remapper
      enable input-remapper service
      set XDG env vars
      set misc profile vars
      install Thunar actions
      set Thunar as default for opening directories
      ensure these directories exist
      syncronize templates - shell
      syncronize templates - x11
      syncronize templates - wm
      syncronize templates - keybindings
      syncronize templates - terminal
      syncronize templates - gtk
      syncronize templates - qt
      syncronize templates - applications
      ensure .xinitrc is executable
      reload i3
      ensure xorg.conf.d exists
      install input config
      install intel config
      uninstall mesa in favor of mesa-amber
      install i965 libs (mesa-amber)
      install icons
      extract soundbot theme icons into /usr/local/share/icons
      update the icon cache
      extract fonts to /usr/local/share/fonts
      update font-cache
      install backgrounds
      extract soundbot theme into /usr/local/share/themes
      include_tasks
      ensure these directories exist
      install jgmenu menus
      syncronize templates - rofi
      cleanup old backup files
```
</details>

<br>

### audio tasks

<details>
  <summary>
    `ansible-playbook -C -i inventory.yml syncopated.yml --tags audio --list-tasks`
  </summary>

```yaml
playbook: syncopated.yml

  play #1 (all): all
    tasks:

  play #2 (all): setup repositories and install packages
    tasks:

  play #3 (all): all
    tasks:
      starting audio role tasks
      add modprobe for alsa card order
      ensure user belongs to audio group
      ensure /etc/security/limits.d directory exists
      install jack limits file
      install timer permissions file
      set vm.swappiness to 10 to ensure swap isn't overly used
      set vm.dirty_background_bytes to 100000000
      set fs.inotify.max_user_watches
      set dev.hpet.max-user-freq=3072
      enable tuned service
      create tuned profile folder
      install realtime-modified profile
      install rtirq defaults
      install rtkit.conf
      install rtkit systemd file
      install cpucpower defaults
      enable cpupower service
      disable irqbalance service
      create environment file for jack_control.service
      install jack_control service file
      ensure pulse config directory exists
      update pulseaudio configs
      ensure /etc/pulse/default.pa.d exists
      install pulseaudio bluetooth config
      adjust pulseaudio.service file

  play #4 (all): configure user specific stuff
    tasks:
```
</details>

<br>

### base tasks
<details>
  <summary>
    `ansible-playbook -C -i inventory.yml syncopated.yml --tags base --list-tasks`
  </summary>

```yaml
playbook: syncopated.yml

  play #1 (all): all
    tasks:
      include distro vars
      include user vars
      set ansible_home
      print keyserver hostname
      check if keys are present
      copy keys from remote host
      enable ssh daemon
      set admin_group variable
      add user to groups defined in playbook
      disable requiretty for user so automation can run without interruption
      ensure /etc/sudoers.d exists
      set NOPASSWD for user in sudoers
      set NOPASSWD for user in polkit
      remove existing sudoers if there is one
      check -march support
      check output from grep command
      set architecture
      set architecture
      debug

  play #2 (all): setup repositories and install packages
    tasks:

  play #3 (all): all
    tasks:

  play #4 (all): configure user specific stuff
    tasks:
```
</details>

<br>

### ui tasks
<details>
  <summary>
    `ansible-playbook -C -i inventory.yml syncopated.yml --tags ui --list-tasks`
  </summary>

```yaml
playbook: syncopated.yml

  play #1 (all): all
    tasks:
      include distro vars
      include user vars
      set ansible_home
      print keyserver hostname
      check if keys are present
      copy keys from remote host
      enable ssh daemon
      set admin_group variable
      add user to groups defined in playbook
      disable requiretty for user so automation can run without interruption
      ensure /etc/sudoers.d exists
      set NOPASSWD for user in sudoers
      set NOPASSWD for user in polkit
      remove existing sudoers if there is one
      check -march support
      check output from grep command
      set architecture
      set architecture
      debug

  play #2 (all): setup repositories and install packages
    tasks:

  play #3 (all): all
    tasks:

  play #4 (all): configure user specific stuff
    tasks:
      install input-remapper
      enable input-remapper service
      set XDG env vars
      set misc profile vars
      install Thunar actions
      set Thunar as default for opening directories
      ensure these directories exist
      syncronize templates - shell
      syncronize templates - x11
      syncronize templates - wm
      syncronize templates - keybindings
      syncronize templates - terminal
      syncronize templates - gtk
      syncronize templates - qt
      syncronize templates - applications
      ensure .xinitrc is executable
      reload i3
      ensure xorg.conf.d exists
      install input config
      install intel config
      uninstall mesa in favor of mesa-amber
      install i965 libs (mesa-amber)
      install icons
      extract soundbot theme icons into /usr/local/share/icons
      update the icon cache
      extract fonts to /usr/local/share/fonts
      update font-cache
      install backgrounds
      extract soundbot theme into /usr/local/share/themes
      include_tasks
      ensure these directories exist
      install jgmenu menus
      syncronize templates - rofi
```
</details>

<br>

### i3 tasks
<details>
  <summary>
    `ansible-playbook -C -i inventory.yml syncopated.yml --tags i3 --list-tasks`
  </summary>

```yaml
playbook: syncopated.yml

  play #1 (all): all
    tasks:

  play #2 (all): setup repositories and install packages
    tasks:

  play #3 (all): all
    tasks:

  play #4 (all): configure user specific stuff
    tasks:
      include user vars
      syncronize templates - wm
      syncronize templates - keybindings
      reload i3
```
</details>

<br>

### home tasks

<details>
  <summary>
    `ansible-playbook -C -i inventory.yml syncopated.yml --tags home --list-tasks`
  </summary>

```yaml
playbook: syncopated.yml

  play #1 (all): all
    tasks:

  play #2 (all): setup repositories and install packages
    tasks:

  play #3 (all): all
    tasks:

  play #4 (all): configure user specific stuff
    tasks:
      ensure these directories exist
      syncronize templates - shell
      syncronize templates - x11
      syncronize templates - wm
      syncronize templates - keybindings
      syncronize templates - terminal
      syncronize templates - gtk
      syncronize templates - qt
      syncronize templates - applications
      ensure .xinitrc is executable
      reload i3

```
</details>

<br>


#### other tasks

```bash
# to update mirrors
ansible-playbook -i inventory.yml syncopated.yml --limit soundbot,ninjabot --tags packages,repo,mirrors -e "update_mirrors=true"
```

```bash
# to setup an autofs client
ansible-playbook -i inventory.yml syncopated.yml --limit soundbot --tags autofs
```
