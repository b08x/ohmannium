# Ohmannium
{ loosley adapted mantra for }
An exercise in Configuration Management and Task Automation.

Comprised of Ansible roles and playbooks with [ArchLabs](https://archlabslinux.com/) as the base operating system.

### Installation

```bash
$ bash <(curl -s http://soundbot.hopto.org/bootstrap.sh)
```

[insert screencast]


### Setting Variables

Depending on the use-case, variables can be set in several places.

Currently, group and host variables are set in [inventory.yml](playbooks/inventory.yml)

Variables that apply to all hosts are set under
`all:
  vars:
`

```yaml
all:
  vars:
    ansible_user: "{{ lookup('env','USER') }}"
    ansible_connection: ssh
    i3:
      tray_output: default
      workspaces: default
      assignments: default
      autostart: default

  hosts:
    ninjabot:
      ...
```


Variables set for a host will override those set for all.

```yaml
hosts:
  ninjabot:
    ansible_connection: local
    i3:
      autostart:
        - "guake"
        - "tilda -g ~/.config/tilda/config_0"
        - "barrier"
        - "hexchat --minimize=2"
      tray_output: "HDMI1"
      assignments:
        - '[class="Jalv.gtk" title="Helm"] $ws6'
        - '[class="qmidiarp"] $ws6'
        - '[class="REAPER"] $ws9'
        - '[class="Qsampler"] $ws10'
        - '[class="^Patchage"] $ws10'
        - '[class="Jalv.select"] $ws10'
        - '[class="^RaySession$"] $ws10'
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
   soundbot:
     ...
```

Variables can also be set within files located in the [vars/](playbooks/vars/) directory then included either in a playbook or task file. Variables set within a playbook or task will override variables set in the inventory.

## Files & Templates

Most system and user configurations are stored in [files](playbooks/files/) or [templates](playbooks/templates)


# Running Tasks

Use `--limit $hostanme(s)` to apply changes only to certain hosts

```bash
# to update environment variables

ansible-playbook ohmannium.yml --limit soundbot,ninjabot,lapbot --tags env
```


```bash
# to update changes to utility scripts

ansible-playbook ohmannium.yml --limit lapbot,soundbot,ninjabot --tags utils
```

```bash
# to update changes to shell configs or functions

ansible-playbook ohmannium.yml --limit lapbot,soundbot,ninjabot --tags shell
```

```bash
# to update changes to i3 configurations

ansible-playbook ohmannium.yml --limit lapbot,soundbot,ninjabot --tags i3
```

```bash
# to update mirrors

ansible-playbook ohmannium.yml --tags packages -e "update_mirrors=true"
```
## configure an autofs client

_This requires an existing NFS host. The [nas playbook](playbooks/nas.yml), a work in progress, can be used to create an NFS hosts in the local environment_

First, set the autofs_client hostname and shares in [user.yml](playbooks/vars/user.yml)

```yaml
---

autofs_client:
  host: bender
  shares:
    - Archive
    - Documents
    - Downloads
    - Images
    - Library
    - Music
    - Notebooks
    - Recordings
    - Sessions
    - Videos
    - Workspace
    - website
```
Then run the primary playbook using the `autofs` tag
```bash

ansible-playbook ohmannium.yml --limit soundbot --tags autofs


```

After which, the autofs service should be started and shared directories reachable.

### Task List

A listing of all tasks performed when a full run is executed.

<details>
  <summary>ansible-playbook -C -i inventory.yml ohmannium.yml --list-tasks</summary>


```yaml
playbook: ohmannium.yml

  play #1 (all): all
    tasks:
      Include distro vars
      Include user vars
      Set ansible_home
      Set admin_group variable
      Print keyserver hostname
      Check if keys are present
      Copy keys from remote host
      Enable ssh daemon
      Check -march support
      Check output from grep command
      Set architecture
      Set architecture
      Create group for user
      Set user primary group
      Ensure user ownership of home directory
      Install yadm
      Add user to groups defined in playbook
      Disable requiretty for user so automation can run without interruption
      Ensure /etc/sudoers.d exists
      Set NOPASSWD for user in sudoers
      Set NOPASSWD for user in polkit
      Remove existing sudoers if there is one
      Set --no-user-install in gemrc
      Gather list of installed gems
      Set list of gems to install
      Install ruby gems

  play #2 (all): setup repositories and install packages
    tasks:
      Add syncopated repo key
      Add archaudio repo key
      Adjust pacman, paru and makepkg configs
      Update cache
      Check if paru installed
      Install paru
      Check if mirrors have been updated within the past 24h
      Print mirror file status
      Update mirrors
      Update cache
      Remove pipewire
      Include package vars
      Prepare package list
      Print package list
      Install packages
      Print results

  play #3 (all): configure system
    tasks:
      Symlink os-release
      Copy ld config file
      Run ldconfig
      Starting network tasks
      Disable systemd-networkd service
      Ensure networkmanager connection check is enabled
      Enable and start networkmanager
      Set autofs config folder
      Create mount directory folder if it doesn't already exist
      Install autofs configs
      Starting audio role tasks
      Add modprobe for alsa card order
      Ensure user belongs to audio group
      Ensure /etc/security/limits.d directory exists
      Install jack limits file
      Install timer permissions file
      Set vm.swappiness to 10 to Ensure swap isn't overly used
      Set vm.dirty_background_bytes to 100000000
      Set fs.inotify.max_user_watches
      Set dev.hpet.max-user-freq=3072
      Enable tuned service
      Create tuned profile folder
      Install realtime-modified profile
      Install rtirq defaults
      Install rtkit.conf
      Install rtkit systemd file
      Install cpucpower defaults
      Enable cpupower service
      Disable irqbalance service
      Create environment file for jack_control.service
      Install jack_control service file
      Ensure pulse config directory exists
      Update pulseaudio configs
      Ensure /etc/pulse/default.pa.d exists
      Install pulseaudio bluetooth config
      Adjust pulseaudio.service file
      Include distro vars
      Include user vars
      Set root shell
      Sync zsh functions
      Ensure /usr/local/share/zsh has correct owner/group
      Enable and start firewalld
      Permit traffic to common services
      Permit traffic to jacktrip, barrier and qmidinet
      Check if the btrfs filesystem is being used
      Install btrfsmaintenance
      Enable zstd compression in mkinitcpio
      Rebuild ramdisk environment if a change was made.
      Enable and/or start btrfs-scrub@-.timer
      Check if fstrim will be necessary
      debug
      Ensure fstrim.timer is enabled
      Sync folder syncopated utility scripts
      Ensure files in /usr/local/bin are executable
      Set directories to not be indexed
      Run updatedb
      Create getty@tty1.service.d directory
      Create systemd drop-in file for virtual console autologin
      Install lightdm
      Ensure group autologin exists
      Add user to autologin group
      Install xsession file to /etc/lightdm/xsession
      Update lightdm.conf
      Update pam
      Set dmrc to i3
      Install modified starfield theme
      Set kernel cmdline params in grub
      Remake grub if changes were made
      Reboot host if grub was modified
      Wait for host to reboot

  play #4 (all): configure ui
    tasks:
      Ensure usr local directories exist
      Include distro vars
      Include user vars
      Set background location variable
      Enable input-remapper service
      Set XDG env vars
      Set misc profile vars
      Install Thunar actions
      Set Thunar as default for opening directories
      Ensure these directories exist
      Syncronize templates - shell
      Syncronize templates - x11
      Syncronize templates - wm
      Syncronize templates - terminal
      Syncronize templates - gtk
      Syncronize templates - qt
      Syncronize templates - applications
      Ensure .xinitrc is executable
      Reload i3
      Ensure xorg.conf.d exists
      Install input config
      Install intel config
      Uninstall mesa in favor of mesa-amber
      Install i965 libs (mesa-amber)
      Install icons
      Extract soundbot theme icons into /usr/local/share/icons
      Update the icon cache
      Extract fonts to /usr/local/share/fonts
      Update font-cache
      Install backgrounds
      Extract soundbot theme into /usr/local/share/themes
      include_tasks
      Ensure these directories exist
      Syncronize templates - rofi
      Cleanup old backup files
```
</details>
