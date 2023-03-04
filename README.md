# Ohmannium

{ a loosley adapted mantra for }

An exercise in Configuration Management and Task Automation for an Audio Production workflow that comprises of FOSS applications on Linux based devices.

Designed to be a flexible framework to manage a variety of tasks and configurations. Ansible is used for this purpose, and can be adapted in any number of ways accomdate.

### Setup

[ArchLabs](https://archlabslinux.com/) is used as the base operating system.

[yadm](https://yadm.io/) is used to bootstrap

```bash
$ bash <(curl -s http://soundbot.hopto.org/bootstrap.sh)
```

### Setting Variables

In this use case variables can be set in the following areas,
in order of least to greatest precedence:

1. [system role defaults](roles/system/defaults/main.yml)
2. [nginx role defaults](roles/nginx/defaults/main.yml)
3. [network role defaults](roles/network/defaults/main.yml)
4. [audio role defaults](roles/audio/defaults/main.yml)
5. [application role defaults](roles/application/defaults/main.yml)
6. [inventory.yml](inventory.yml)
7. group_vars
8. host_vars
9. [vars/distro](vars/distro)
10. [vars/packages](vars/packages)
10. [network role variables](roles/network/vars/main.yml)


group_vars and host_vars are managed with yadm and are symlinked to $ANSIBLE_HOME



# Running Tasks with Tags

Use `--limit $hostanme(s)` to apply changes only to certain hosts

<details>
  <summary>ansible-playbook -C -i inventory.yml base.yml --list-tags</summary>
```yaml
  playbook: base.yml

    play #1 (devel): devel	TAGS: []
        TASK TAGS: [alacritty, alias, audio, autofs, autologin, backgrounds, base, btrfs, cleanup, cpupower, desktop, dunst, env, filesystem, firewall, fonts, grub, gtk, home, htop, i3, i965, icons, initram, intel, jack, jgmenu, keybindings, keys, kitty, lightdm, menu, mirrors, modprobe, netork, networkmanager, nfs, ntp, packages, pam, picom, profile, pulseaudio, qt, qutebrowser, repo, rofi, rsyncd, rtirq, rtkit, ruby, shell, sonicpi, ssh, sudoers, sxhkd, sysctl, system, terminal, theme, thunar, tilda, trim, tuned, tuning, ui, updatedb, user, utils, x11, xdg, yadm, zim, zsh]
```
</details>


```bash
# to update environment variables

ansible-playbook base.yml --tags env
```

```bash
# to update changes to utility scripts

ansible-playbook base.yml --tags utils
```

```bash
# to update changes to shell configs or functions

ansible-playbook base.yml --tags shell
```

```bash
# to update changes to i3 configurations

ansible-playbook base.yml --tags i3
```

```bash
# to update mirrors

ansible-playbook base.yml --tags mirrors -e "update_mirrors=true"
```

List tasks that would be run against a given tag. For example:

<details>
  <summary>ansible-playbook -C base.yml --tags audio --list-tasks</summary>
```yaml
  playbook: base.yml

    play #1 (devel): devel	TAGS: []
      tasks:
        audio : Starting audio role tasks	TAGS: [audio]
        audio : Add modprobe for alsa card order	TAGS: [audio, modprobe]
        audio : Ensure user belongs to audio group	TAGS: [audio, tuning]
        audio : Ensure /etc/security/limits.d directory exists	TAGS: [audio, tuning]
        audio : Install jack limits file	TAGS: [audio, tuning]
        audio : Install timer permissions file	TAGS: [audio, tuning]
        audio : Set vm.swappiness to 10 to Ensure swap isn't overly used	TAGS: [audio, sysctl, tuning]
        audio : Set vm.dirty_background_bytes to 100000000	TAGS: [audio, sysctl, tuning]
        audio : Set fs.inotify.max_user_watches	TAGS: [audio, sysctl, tuning]
        audio : Set dev.hpet.max-user-freq=3072	TAGS: [audio, sysctl, tuning]
        audio : Enable tuned service	TAGS: [audio, tuned, tuning]
        audio : Create tuned profile folder	TAGS: [audio, tuned, tuning]
        audio : Install realtime-modified profile	TAGS: [audio, tuned, tuning]
        audio : Install rtirq defaults	TAGS: [audio, rtirq, rtkit, tuning]
        audio : Install rtkit.conf	TAGS: [audio, rtirq, rtkit, tuning]
        audio : Install rtkit systemd file	TAGS: [audio, rtirq, rtkit, tuning]
        audio : Install cpucpower defaults	TAGS: [audio, cpupower, tuning]
        audio : Enable cpupower service	TAGS: [audio, cpupower, tuning]
        audio : Disable irqbalance service	TAGS: [audio, tuning]
        audio : Create environment file for jack_control.service	TAGS: [audio, jack]
        audio : Install jack_control service file	TAGS: [audio, jack]
        audio : Ensure pulse config directory exists	TAGS: [audio, pulseaudio]
        audio : Update pulseaudio configs	TAGS: [audio, pulseaudio]
        audio : Ensure /etc/pulse/default.pa.d exists	TAGS: [audio, pulseaudio]
        audio : Install pulseaudio bluetooth config	TAGS: [audio, pulseaudio]
        audio : Adjust pulseaudio.service file	TAGS: [audio, pulseaudio]
```
</details>

### Task List

A listing of all tasks performed when a full run is executed.

<details>
  <summary>ansible-playbook -C -i inventory.yml base.yml --list-tasks</summary>


```yaml
playbook: base.yml

  play #1 (all): all	TAGS: []
    tasks:
      Include distro vars	TAGS: [base]
      Symlink os-release	TAGS: [base]
      Set ansible_home	TAGS: [base]
      Set admin_group variable	TAGS: [base]
      Print keyserver hostname	TAGS: [ssh]
      Check if keys are present	TAGS: [ssh]
      Copy keys from remote host	TAGS: [keys, ssh]
      Enable ssh daemon	TAGS: [ssh]
      Check -march support	TAGS: [base, packages, repo]
      Check output from grep command	TAGS: [base, packages, repo]
      Set architecture	TAGS: [base, packages, repo]
      Set architecture	TAGS: [base, packages, repo]
      Ensure usr local directories exist	TAGS: [theme]
      Set background location variable	TAGS: [theme, x11]
      Create group for user	TAGS: [base, user]
      Set user primary group	TAGS: [base, user]
      Ensure user ownership of home directory	TAGS: [base, user]
      Install yadm	TAGS: [base, user, yadm]
      Add user to groups defined in playbook	TAGS: [base, sudoers]
      Disable requiretty for user so automation can run without interruption	TAGS: [base, sudoers]
      Ensure /etc/sudoers.d exists	TAGS: [base, sudoers]
      Set NOPASSWD for user in sudoers	TAGS: [base, sudoers]
      Set NOPASSWD for user in polkit	TAGS: [base, sudoers]
      Set --no-user-install in gemrc	TAGS: [base, ruby]
      Gather list of installed gems	TAGS: [base, ruby]
      Set list of gems to install	TAGS: [base, ruby]
      Install ruby gems	TAGS: [base, ruby]
      Set root shell	TAGS: [zsh]
      Sync zsh functions	TAGS: [zsh]
      Ensure /usr/local/share/zsh has correct owner/group	TAGS: [zsh]
      include_tasks	TAGS: [base]
      network : Starting network tasks	TAGS: [netork]
      network : Disable systemd-networkd service	TAGS: [netork, networkmanager]
      network : Ensure networkmanager connection check is enabled	TAGS: [netork, networkmanager]
      network : Enable and start networkmanager	TAGS: [netork, networkmanager]
      network : Set autofs config folder	TAGS: [autofs, netork]
      network : Create mount directory folder if it doesn't already exist	TAGS: [autofs, netork]
      network : Install autofs configs	TAGS: [autofs, netork]
      audio : Starting audio role tasks	TAGS: [audio]
      audio : Add modprobe for alsa card order	TAGS: [audio, modprobe]
      audio : Ensure user belongs to audio group	TAGS: [audio, tuning]
      audio : Ensure /etc/security/limits.d directory exists	TAGS: [audio, tuning]
      audio : Install jack limits file	TAGS: [audio, tuning]
      audio : Install timer permissions file	TAGS: [audio, tuning]
      audio : Set vm.swappiness to 10 to Ensure swap isn't overly used	TAGS: [audio, sysctl, tuning]
      audio : Set vm.dirty_background_bytes to 100000000	TAGS: [audio, sysctl, tuning]
      audio : Set fs.inotify.max_user_watches	TAGS: [audio, sysctl, tuning]
      audio : Set dev.hpet.max-user-freq=3072	TAGS: [audio, sysctl, tuning]
      audio : Enable tuned service	TAGS: [audio, tuned, tuning]
      audio : Create tuned profile folder	TAGS: [audio, tuned, tuning]
      audio : Install realtime-modified profile	TAGS: [audio, tuned, tuning]
      audio : Install rtirq defaults	TAGS: [audio, rtirq, rtkit, tuning]
      audio : Install rtkit.conf	TAGS: [audio, rtirq, rtkit, tuning]
      audio : Install rtkit systemd file	TAGS: [audio, rtirq, rtkit, tuning]
      audio : Install cpucpower defaults	TAGS: [audio, cpupower, tuning]
      audio : Enable cpupower service	TAGS: [audio, cpupower, tuning]
      audio : Disable irqbalance service	TAGS: [audio, tuning]
      audio : Create environment file for jack_control.service	TAGS: [audio, jack]
      audio : Install jack_control service file	TAGS: [audio, jack]
      audio : Ensure pulse config directory exists	TAGS: [audio, pulseaudio]
      audio : Update pulseaudio configs	TAGS: [audio, pulseaudio]
      audio : Ensure /etc/pulse/default.pa.d exists	TAGS: [audio, pulseaudio]
      audio : Install pulseaudio bluetooth config	TAGS: [audio, pulseaudio]
      audio : Adjust pulseaudio.service file	TAGS: [audio, pulseaudio]
      system : Enable and start firewalld	TAGS: [firewall, system]
      system : Permit traffic to common services	TAGS: [firewall, nfs, ntp, rsyncd, ssh, system]
      system : Permit traffic to jacktrip, barrier and qmidinet	TAGS: [firewall, system]
      system : Collect only selected facts	TAGS: [filesystem, system]
      system : Check if the btrfs filesystem is being used	TAGS: [btrfs, filesystem, system]
      system : Install btrfsmaintenance	TAGS: [btrfs, filesystem, system]
      system : Enable zstd compression in mkinitcpio	TAGS: [filesystem, initram, system]
      system : Rebuild ramdisk environment if a change was made.	TAGS: [filesystem, initram, system]
      system : Enable and/or start btrfs-scrub@-.timer	TAGS: [btrfs, filesystem, system]
      system : Check if fstrim will be necessary	TAGS: [filesystem, system, trim]
      system : Ensure fstrim.timer is enabled	TAGS: [filesystem, system, trim]
      system : Sync folder syncopated utility scripts	TAGS: [system, utils]
      system : Ensure files in /usr/local/bin are executable	TAGS: [system, utils]
      system : Set directories to not be indexed	TAGS: [system, updatedb]
      system : Run updatedb	TAGS: [system, updatedb]
      system : Create getty@tty1.service.d directory	TAGS: [autologin, system]
      system : Create systemd drop-in file for virtual console autologin	TAGS: [autologin, system]
      system : Install lightdm	TAGS: [autologin, lightdm, system]
      system : Ensure group autologin exists	TAGS: [autologin, lightdm, system]
      system : Add user to autologin group	TAGS: [autologin, lightdm, system]
      system : Install xsession file to /etc/lightdm/xsession	TAGS: [autologin, lightdm, system]
      system : Update lightdm.conf	TAGS: [autologin, lightdm, system]
      system : Update pam	TAGS: [autologin, lightdm, pam, system]
      system : Set dmrc to i3	TAGS: [autologin, system]
      system : Install modified starfield theme	TAGS: [grub, system]
      system : Set kernel cmdline params in grub	TAGS: [grub, system]
      system : Remake grub if changes were made	TAGS: [grub, system]
      system : Remake grub if changes were made	TAGS: [grub, system]
      system : Reboot host if grub was modified	TAGS: [grub, system]
      system : Wait for host to reboot	TAGS: [grub, system]
      system : Collect only selected facts	TAGS: [system, ui]
      system : Enable input-remapper service	TAGS: [system, ui]
      system : Set XDG env vars	TAGS: [env, system, ui, xdg]
      system : Set misc profile vars	TAGS: [env, system, ui]
      system : Install Thunar actions	TAGS: [system, thunar, ui]
      system : Set Thunar as default for opening directories	TAGS: [system, thunar, ui]
      system : Ensure these directories exist	TAGS: [home, system]
      system : Synchronize templates - shell	TAGS: [alias, home, profile, shell, system, zsh]
      system : Synchronize templates - x11	TAGS: [home, profile, system, x11]
      system : Synchronize templates - wm	TAGS: [dunst, home, i3, keybindings, picom, system]
      system : Synchronize templates - terminal	TAGS: [alacritty, home, kitty, system, terminal, tilda]
      system : Synchronize templates - gtk	TAGS: [gtk, home, system, theme]
      system : Synchronize templates - qt	TAGS: [home, qt, system, theme]
      system : Synchronize templates - applications	TAGS: [home, htop, qutebrowser, sonicpi, system, theme, zim]
      system : Ensure .xinitrc is executable	TAGS: [home, profile, system, x11]
      system : Reload i3	TAGS: [dunst, home, i3, keybindings, picom, sxhkd, system]
      system : Collect only selected facts	TAGS: [system, x11]
      system : Ensure xorg.conf.d exists	TAGS: [system, x11]
      system : Install input config	TAGS: [system, x11]
      system : Install intel config	TAGS: [i965, intel, system, x11]
      system : Uninstall mesa in favor of mesa-amber	TAGS: [i965, intel, system, x11]
      system : Install i965 libs (mesa-amber)	TAGS: [i965, intel, system, x11]
      system : Install icons	TAGS: [icons, system, theme]
      system : Extract soundbot theme icons into /usr/local/share/icons	TAGS: [icons, system, theme]
      system : Update the icon cache	TAGS: [icons, system, theme]
      system : Extract fonts to /usr/local/share/fonts	TAGS: [fonts, system, theme]
      system : Install fonts.conf	TAGS: [fonts, system, theme]
      system : Update font-cache	TAGS: [fonts, system, theme]
      system : Install backgrounds	TAGS: [backgrounds, system, theme]
      system : Extract soundbot theme into /usr/local/share/themes	TAGS: [system, theme]
      system : Create /etc/xdg/menus and /usr/share/desktop-entries	TAGS: [system, xdg]
      system : Install application menu	TAGS: [menu, system, xdg]
      system : Install menus	TAGS: [menu, system, xdg]
      system : Install directory entries	TAGS: [menu, system, xdg]
      system : Install Ambisonics desktop entries	TAGS: [desktop, system, xdg]
      system : Update desktop database	TAGS: [system, xdg]
      system : Ensure these directories exist	TAGS: [jgmenu, menu, rofi, system]
      system : Synchronize templates - rofi	TAGS: [menu, rofi, system]
      Cleanup old backup files	TAGS: [cleanup]
      Reboot host	TAGS: []
      Wait for host to reboot	TAGS: []

```
</details>
