# Syncopated Linux

An exercise in configuration management for an audio production environment.


# Install

At current this works with ArchLabs. with some adjustments this could be used with most distributions.

```bash
$ bash <(curl -s http://soundbot.hopto.org/bootstrap.sh)
```

[insert screencast]


# Variables

Depending on the use-case, variables can be set in several different files.

Variables can be set in [inventory.yml](inventory.yml)

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

Variables can also be set within files located in the [vars/](vars/) directory then included either in a playbook or task file. Variables set within a playbook or task will override variables set in inventory.



# Usage

## all tasks
<details>
  <summary>`ansible-playbook -C -i inventory.yml syncopated.yml --list-tasks`</summary>


```yaml
playbook: syncopated.yml

  play #1 (all): all	TAGS: [base,ui,packages]
    tasks:
      include distro vars	TAGS: [base, packages, ui]
      include user vars	TAGS: [base, packages, ui]
      set ansible_home	TAGS: [base, packages, testing, ui]
      print keyserver hostname	TAGS: [base, packages, ssh, ui]
      check if keys are present	TAGS: [base, packages, ssh, ui]
      copy keys from remote host	TAGS: [base, keys, packages, ssh, ui]
      enable ssh daemon	TAGS: [base, packages, ssh, ui]
      set admin_group variable	TAGS: [base, packages, sudoers, ui]
      add user to groups defined in playbook	TAGS: [base, packages, sudoers, ui]
      disable requiretty for user so automation can run without interruption	TAGS: [base, packages, sudoers, ui]
      ensure /etc/sudoers.d exists	TAGS: [base, packages, sudoers, ui]
      set NOPASSWD for user in sudoers	TAGS: [base, packages, sudoers, ui]
      set NOPASSWD for user in polkit	TAGS: [base, packages, sudoers, ui]
      remove existing sudoers if there is one	TAGS: [base, packages, sudoers, ui]
      check -march support	TAGS: [base, flags, packages, repo, ui]
      check output from grep command	TAGS: [base, flags, packages, repo, ui]
      set architecture	TAGS: [base, flags, packages, repo, ui]
      set architecture	TAGS: [base, flags, packages, repo, ui]
      debug	TAGS: [base, packages, ui]

  play #2 (all): setup repositories and install packages	TAGS: [packages,testing]
    tasks:
      add syncopated repo key	TAGS: [packages, repo, testing]
      add archaudio repo key	TAGS: [packages, repo, testing]
      adjust pacman, paru and makepkg configs	TAGS: [makepkg, packages, pacman, paru, repo, testing]
      update cache	TAGS: [packages, testing]
      check if paru installed	TAGS: [packages, paru, testing]
      install paru	TAGS: [packages, paru, testing]
      check if mirrors have been updated within the past 24h	TAGS: [mirrors, packages, testing]
      print output	TAGS: [mirrors, packages, testing]
      update mirrors	TAGS: [mirrors, packages, testing]
      update and upgrade	TAGS: [packages, testing]
      remove pipewire	TAGS: [packages, testing]
      include package vars	TAGS: [packages, testing]
      prepare pacage list	TAGS: [packages, testing]
      print package list	TAGS: [packages, testing]
      install packages	TAGS: [packages, testing]
      print results	TAGS: [packages, testing]

  play #3 (all): all	TAGS: []
    tasks:
      symlink os-release	TAGS: []
      install systemd configs	TAGS: [logging]
      set system log level config	TAGS: [logging]
      set user log level config	TAGS: [logging]
      reload systemd	TAGS: [logging]
      set root shell	TAGS: [shell]
      sync zsh functions	TAGS: [shell, zsh]
      ensure /usr/local/share/zsh has correct owner/group	TAGS: [shell, zsh]
      create group for user	TAGS: [user]
      set user primary group	TAGS: [user]
      ensure user ownership of home directory	TAGS: [user]
      install yadm	TAGS: [user, yadm]
      copy clonedots script into user home	TAGS: [user, yadm]
      copy ld config file	TAGS: []
      run ldconfig	TAGS: []
      starting network tasks	TAGS: [autofs, firewall, netork]
      disable systemd-networkd service	TAGS: [autofs, firewall, netork, networkmanager]
      ensure networkmanager connection check is enabled	TAGS: [autofs, firewall, netork, networkmanager]
      enable and start networkmanager	TAGS: [autofs, firewall, netork, networkmanager]
      set ntp servers in timesyncd.conf	TAGS: [autofs, firewall, netork, networkmanager]
      set autofs config folder	TAGS: [autofs, firewall, netork]
      create mount directory folder if it doesn't already exist	TAGS: [autofs, firewall, netork]
      install autofs configs	TAGS: [autofs, firewall, netork]
      starting audio role tasks	TAGS: [alsa, audio, jack, pulseaudio]
      add modprobe for alsa card order	TAGS: [alsa, audio, jack, modprobe, pulseaudio]
      ensure user belongs to audio group	TAGS: [alsa, audio, jack, pulseaudio, tuning]
      ensure /etc/security/limits.d directory exists	TAGS: [alsa, audio, jack, pulseaudio, tuning]
      install jack limits file	TAGS: [alsa, audio, jack, pulseaudio, tuning]
      install timer permissions file	TAGS: [alsa, audio, jack, pulseaudio, tuning]
      set vm.swappiness to 10 to ensure swap isn't overly used	TAGS: [alsa, audio, jack, pulseaudio, sysctl, tuning]
      set vm.dirty_background_bytes to 100000000	TAGS: [alsa, audio, jack, pulseaudio, sysctl, tuning]
      set fs.inotify.max_user_watches	TAGS: [alsa, audio, jack, pulseaudio, sysctl, tuning]
      set dev.hpet.max-user-freq=3072	TAGS: [alsa, audio, jack, pulseaudio, sysctl, tuning]
      enable tuned service	TAGS: [alsa, audio, jack, pulseaudio, tuned, tuning]
      create tuned profile folder	TAGS: [alsa, audio, jack, pulseaudio, tuned, tuning]
      install realtime-modified profile	TAGS: [alsa, audio, jack, pulseaudio, tuned, tuning]
      install rtirq defaults	TAGS: [alsa, audio, jack, pulseaudio, rtirq, rtkit, tuning]
      install rtkit.conf	TAGS: [alsa, audio, jack, pulseaudio, rtirq, rtkit, tuning]
      install rtkit systemd file	TAGS: [alsa, audio, jack, pulseaudio, rtirq, rtkit, tuning]
      install cpucpower defaults	TAGS: [alsa, audio, cpupower, jack, pulseaudio, tuning]
      enable cpupower service	TAGS: [alsa, audio, cpupower, jack, pulseaudio, tuning]
      disable irqbalance service	TAGS: [alsa, audio, jack, pulseaudio, tuning]
      create environment file for jack_control.service	TAGS: [alsa, audio, jack, pulseaudio]
      install jack_control service file	TAGS: [alsa, audio, jack, pulseaudio]
      ensure pulse config directory exists	TAGS: [alsa, audio, jack, pulseaudio]
      update pulseaudio configs	TAGS: [alsa, audio, jack, pulseaudio]
      ensure /etc/pulse/default.pa.d exists	TAGS: [alsa, audio, jack, pulseaudio]
      install pulseaudio bluetooth config	TAGS: [alsa, audio, jack, pulseaudio]
      adjust pulseaudio.service file	TAGS: [alsa, audio, jack, pulseaudio]
      enable and start firewalld	TAGS: [firewall]
      permit traffic to common services	TAGS: [firewall, nfs, ntp, rsyncd, ssh]
      permit traffic to jacktrip, barrier and qmidinet	TAGS: [firewall]
      check if the btrfs filesystem is being used	TAGS: [btrfs, filesystem]
      install btrfsmaintenance	TAGS: [btrfs, filesystem]
      Enable zstd compression in mkinitcpio	TAGS: [filesystem, initram]
      Rebuild ramdisk environment if a change was made.	TAGS: [filesystem, initram]
      enable and/or start btrfs-scrub@-.timer	TAGS: [btrfs, filesystem]
      check if fstrim will be necessary	TAGS: [filesystem, trim]
      debug	TAGS: [filesystem, trim]
      ensure fstrim.timer is enabled	TAGS: [filesystem, trim]
      sync folder syncopated utility scripts	TAGS: [utils]
      ensure files in /usr/local/bin are executable	TAGS: [utils]
      set directories to not be indexed	TAGS: [updatedb]
      run updatedb	TAGS: [updatedb]
      create getty@tty1.service.d directory	TAGS: [autologin]
      create systemd drop-in file for virtual console autologin	TAGS: [autologin]
      install lightdm	TAGS: [autologin, lightdm]
      ensure group autologin exists	TAGS: [autologin, lightdm]
      add user to autologin group	TAGS: [autologin, lightdm]
      install xsession file to /etc/lightdm/xsession	TAGS: [autologin, lightdm]
      update lightdm.conf	TAGS: [autologin, lightdm]
      update pam	TAGS: [autologin, lightdm, pam]
      set dmrc to i3	TAGS: [autologin]
      install modified starfield theme	TAGS: [grub]
      set kernel cmdline params in grub	TAGS: [grub]
      remake grub if changes were made	TAGS: [grub]
      remake grub if changes were made	TAGS: [grub]
      reboot host if grub was modified	TAGS: [grub]
      wait for host to reboot	TAGS: [grub]
      reboot host	TAGS: []
      wait for host to reboot	TAGS: []

  play #4 (all): configure user specific stuff	TAGS: []
    tasks:
      include vars	TAGS: []
      include user vars	TAGS: [i3]
      ensure usr local directories exist	TAGS: [folders]
      install input-remapper	TAGS: [ui]
      enable input-remapper service	TAGS: [ui]
      set XDG env vars	TAGS: [env, ui, xdg]
      set misc profile vars	TAGS: [env, ui]
      install Thunar actions	TAGS: [thunar, ui]
      set Thunar as default for opening directories	TAGS: [thunar, ui]
      ensure these directories exist	TAGS: [home, ui]
      syncronize templates - shell	TAGS: [alias, home, profile, shell, ui, zsh]
      syncronize templates - x11	TAGS: [home, profile, ui, x11]
      syncronize templates - wm	TAGS: [dunst, home, i3, picom, ui]
      syncronize templates - keybindings	TAGS: [home, i3, keybindings, sxhkd, ui]
      syncronize templates - terminal	TAGS: [alacritty, home, kitty, terminal, tilda, ui]
      syncronize templates - gtk	TAGS: [gtk, home, ui]
      syncronize templates - qt	TAGS: [home, qt, ui]
      syncronize templates - applications	TAGS: [home, htop, qutebrowser, sonicpi, ui, zim]
      ensure .xinitrc is executable	TAGS: [home, profile, ui, x11]
      reload i3	TAGS: [dunst, home, i3, keybindings, picom, sxhkd, ui]
      ensure xorg.conf.d exists	TAGS: [ui, x11]
      install input config	TAGS: [ui, x11]
      install intel config	TAGS: [i965, intel, ui, x11]
      uninstall mesa in favor of mesa-amber	TAGS: [i965, intel, ui, x11]
      install i965 libs (mesa-amber)	TAGS: [i965, intel, ui, x11]
      install icons	TAGS: [icons, theme, ui]
      extract soundbot theme icons into /usr/local/share/icons	TAGS: [icons, theme, ui]
      update the icon cache	TAGS: [icons, theme, ui]
      extract fonts to /usr/local/share/fonts	TAGS: [fonts, theme, ui]
      update font-cache	TAGS: [fonts, theme, ui]
      install backgrounds	TAGS: [backgrounds, theme, ui]
      extract soundbot theme into /usr/local/share/themes	TAGS: [theme, ui]
      include_tasks	TAGS: [menu, ui, xdg]
      ensure these directories exist	TAGS: [jgmenu, menu, rofi, ui]
      install jgmenu menus	TAGS: [jgmenu, menu, ui]
      syncronize templates - rofi	TAGS: [menu, rofi, ui]
      cleanup old backup files	TAGS: [cleanup]
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

  play #1 (all): all	TAGS: [ui,base,packages]
    tasks:

  play #2 (all): setup repositories and install packages	TAGS: [packages,testing]
    tasks:

  play #3 (all): all	TAGS: []
    tasks:
      starting audio role tasks	TAGS: [alsa, audio, jack, pulseaudio]
      add modprobe for alsa card order	TAGS: [alsa, audio, jack, modprobe, pulseaudio]
      ensure user belongs to audio group	TAGS: [alsa, audio, jack, pulseaudio, tuning]
      ensure /etc/security/limits.d directory exists	TAGS: [alsa, audio, jack, pulseaudio, tuning]
      install jack limits file	TAGS: [alsa, audio, jack, pulseaudio, tuning]
      install timer permissions file	TAGS: [alsa, audio, jack, pulseaudio, tuning]
      set vm.swappiness to 10 to ensure swap isn't overly used	TAGS: [alsa, audio, jack, pulseaudio, sysctl, tuning]
      set vm.dirty_background_bytes to 100000000	TAGS: [alsa, audio, jack, pulseaudio, sysctl, tuning]
      set fs.inotify.max_user_watches	TAGS: [alsa, audio, jack, pulseaudio, sysctl, tuning]
      set dev.hpet.max-user-freq=3072	TAGS: [alsa, audio, jack, pulseaudio, sysctl, tuning]
      enable tuned service	TAGS: [alsa, audio, jack, pulseaudio, tuned, tuning]
      create tuned profile folder	TAGS: [alsa, audio, jack, pulseaudio, tuned, tuning]
      install realtime-modified profile	TAGS: [alsa, audio, jack, pulseaudio, tuned, tuning]
      install rtirq defaults	TAGS: [alsa, audio, jack, pulseaudio, rtirq, rtkit, tuning]
      install rtkit.conf	TAGS: [alsa, audio, jack, pulseaudio, rtirq, rtkit, tuning]
      install rtkit systemd file	TAGS: [alsa, audio, jack, pulseaudio, rtirq, rtkit, tuning]
      install cpucpower defaults	TAGS: [alsa, audio, cpupower, jack, pulseaudio, tuning]
      enable cpupower service	TAGS: [alsa, audio, cpupower, jack, pulseaudio, tuning]
      disable irqbalance service	TAGS: [alsa, audio, jack, pulseaudio, tuning]
      create environment file for jack_control.service	TAGS: [alsa, audio, jack, pulseaudio]
      install jack_control service file	TAGS: [alsa, audio, jack, pulseaudio]
      ensure pulse config directory exists	TAGS: [alsa, audio, jack, pulseaudio]
      update pulseaudio configs	TAGS: [alsa, audio, jack, pulseaudio]
      ensure /etc/pulse/default.pa.d exists	TAGS: [alsa, audio, jack, pulseaudio]
      install pulseaudio bluetooth config	TAGS: [alsa, audio, jack, pulseaudio]
      adjust pulseaudio.service file	TAGS: [alsa, audio, jack, pulseaudio]

  play #4 (all): configure user specific stuff	TAGS: []
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

  play #1 (all): all	TAGS: [ui,base,packages,shell]
    tasks:
      include distro vars	TAGS: [base, packages, shell, ui]
      include user vars	TAGS: [base, packages, shell, ui]
      set ansible_home	TAGS: [base, packages, shell, testing, ui]
      print keyserver hostname	TAGS: [base, packages, shell, ssh, ui]
      check if keys are present	TAGS: [base, packages, shell, ssh, ui]
      copy keys from remote host	TAGS: [base, keys, packages, shell, ssh, ui]
      enable ssh daemon	TAGS: [base, packages, shell, ssh, ui]
      set admin_group variable	TAGS: [base, packages, shell, sudoers, ui]
      add user to groups defined in playbook	TAGS: [base, packages, shell, sudoers, ui]
      disable requiretty for user so automation can run without interruption	TAGS: [base, packages, shell, sudoers, ui]
      ensure /etc/sudoers.d exists	TAGS: [base, packages, shell, sudoers, ui]
      set NOPASSWD for user in sudoers	TAGS: [base, packages, shell, sudoers, ui]
      set NOPASSWD for user in polkit	TAGS: [base, packages, shell, sudoers, ui]
      remove existing sudoers if there is one	TAGS: [base, packages, shell, sudoers, ui]
      check -march support	TAGS: [base, flags, packages, repo, shell, ui]
      check output from grep command	TAGS: [base, flags, packages, repo, shell, ui]
      set architecture	TAGS: [base, flags, packages, repo, shell, ui]
      set architecture	TAGS: [base, flags, packages, repo, shell, ui]
      debug	TAGS: [base, packages, shell, ui]

  play #2 (all): setup repositories and install packages	TAGS: [testing,packages]
    tasks:

  play #3 (all): all	TAGS: []
    tasks:

  play #4 (all): configure user specific stuff	TAGS: []
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

  play #1 (all): all	TAGS: [packages,ui,shell,base]
    tasks:
      include distro vars	TAGS: [base, packages, shell, ui]
      include user vars	TAGS: [base, packages, shell, ui]
      set ansible_home	TAGS: [base, packages, shell, testing, ui]
      print keyserver hostname	TAGS: [base, packages, shell, ssh, ui]
      check if keys are present	TAGS: [base, packages, shell, ssh, ui]
      copy keys from remote host	TAGS: [base, keys, packages, shell, ssh, ui]
      enable ssh daemon	TAGS: [base, packages, shell, ssh, ui]
      set admin_group variable	TAGS: [base, packages, shell, sudoers, ui]
      add user to groups defined in playbook	TAGS: [base, packages, shell, sudoers, ui]
      disable requiretty for user so automation can run without interruption	TAGS: [base, packages, shell, sudoers, ui]
      ensure /etc/sudoers.d exists	TAGS: [base, packages, shell, sudoers, ui]
      set NOPASSWD for user in sudoers	TAGS: [base, packages, shell, sudoers, ui]
      set NOPASSWD for user in polkit	TAGS: [base, packages, shell, sudoers, ui]
      remove existing sudoers if there is one	TAGS: [base, packages, shell, sudoers, ui]
      check -march support	TAGS: [base, flags, packages, repo, shell, ui]
      check output from grep command	TAGS: [base, flags, packages, repo, shell, ui]
      set architecture	TAGS: [base, flags, packages, repo, shell, ui]
      set architecture	TAGS: [base, flags, packages, repo, shell, ui]
      debug	TAGS: [base, packages, shell, ui]

  play #2 (all): setup repositories and install packages	TAGS: [packages,testing]
    tasks:

  play #3 (all): all	TAGS: []
    tasks:

  play #4 (all): configure user specific stuff	TAGS: []
    tasks:
      install input-remapper	TAGS: [ui]
      enable input-remapper service	TAGS: [ui]
      set XDG env vars	TAGS: [env, ui, xdg]
      set misc profile vars	TAGS: [env, ui]
      install Thunar actions	TAGS: [thunar, ui]
      set Thunar as default for opening directories	TAGS: [thunar, ui]
      ensure these directories exist	TAGS: [home, ui]
      syncronize templates - shell	TAGS: [alias, home, profile, shell, ui, zsh]
      syncronize templates - x11	TAGS: [home, profile, ui, x11]
      syncronize templates - wm	TAGS: [dunst, home, i3, picom, ui]
      syncronize templates - keybindings	TAGS: [home, i3, keybindings, sxhkd, ui]
      syncronize templates - terminal	TAGS: [alacritty, home, kitty, terminal, tilda, ui]
      syncronize templates - gtk	TAGS: [gtk, home, ui]
      syncronize templates - qt	TAGS: [home, qt, ui]
      syncronize templates - applications	TAGS: [home, htop, qutebrowser, sonicpi, ui, zim]
      ensure .xinitrc is executable	TAGS: [home, profile, ui, x11]
      reload i3	TAGS: [dunst, home, i3, keybindings, picom, sxhkd, ui]
      ensure xorg.conf.d exists	TAGS: [ui, x11]
      install input config	TAGS: [ui, x11]
      install intel config	TAGS: [i965, intel, ui, x11]
      uninstall mesa in favor of mesa-amber	TAGS: [i965, intel, ui, x11]
      install i965 libs (mesa-amber)	TAGS: [i965, intel, ui, x11]
      install icons	TAGS: [icons, theme, ui]
      extract soundbot theme icons into /usr/local/share/icons	TAGS: [icons, theme, ui]
      update the icon cache	TAGS: [icons, theme, ui]
      extract fonts to /usr/local/share/fonts	TAGS: [fonts, theme, ui]
      update font-cache	TAGS: [fonts, theme, ui]
      install backgrounds	TAGS: [backgrounds, theme, ui]
      extract soundbot theme into /usr/local/share/themes	TAGS: [theme, ui]
      include_tasks	TAGS: [menu, ui, xdg]
      ensure these directories exist	TAGS: [jgmenu, menu, rofi, ui]
      install jgmenu menus	TAGS: [jgmenu, menu, ui]
      syncronize templates - rofi	TAGS: [menu, rofi, ui]
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

  play #1 (all): all	TAGS: [ui,packages,shell,base]
    tasks:

  play #2 (all): setup repositories and install packages	TAGS: [packages,testing]
    tasks:

  play #3 (all): all	TAGS: []
    tasks:

  play #4 (all): configure user specific stuff	TAGS: []
    tasks:
      include user vars	TAGS: [i3]
      syncronize templates - wm	TAGS: [dunst, home, i3, picom, ui]
      syncronize templates - keybindings	TAGS: [home, i3, keybindings, sxhkd, ui]
      reload i3	TAGS: [dunst, home, i3, keybindings, picom, sxhkd, ui]
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

  play #1 (all): all	TAGS: [base,packages,ui]
    tasks:

  play #2 (all): setup repositories and install packages	TAGS: [packages,testing]
    tasks:

  play #3 (all): all	TAGS: []
    tasks:

  play #4 (all): configure user specific stuff	TAGS: []
    tasks:
      ensure these directories exist	TAGS: [home, ui]
      syncronize templates - shell	TAGS: [alias, home, profile, shell, ui, zsh]
      syncronize templates - x11	TAGS: [home, profile, ui, x11]
      syncronize templates - wm	TAGS: [dunst, home, i3, picom, ui]
      syncronize templates - keybindings	TAGS: [home, i3, keybindings, sxhkd, ui]
      syncronize templates - terminal	TAGS: [alacritty, home, kitty, terminal, tilda, ui]
      syncronize templates - gtk	TAGS: [gtk, home, ui]
      syncronize templates - qt	TAGS: [home, qt, ui]
      syncronize templates - applications	TAGS: [home, htop, qutebrowser, sonicpi, ui, zim]
      ensure .xinitrc is executable	TAGS: [home, profile, ui, x11]
      reload i3	TAGS: [dunst, home, i3, keybindings, picom, sxhkd, ui]

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



# About

```yaml
become = True
```

## PAQ { possibly asked questions }

> There are so many ways to go about doing all of this...you picked this one?

Sort of.
