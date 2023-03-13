# sxhkd

| key                          | command                                               |                 |
|------------------------------|-------------------------------------------------------|-----------------|
| super + Menu                 | `cat ~/.config/jgmenu/apps.csv | jgmenu --simple`     |                 |
| super + o ; {g,a,k,v}        | {guake,alacritty,jack-keyboard,vmpk}                  |                 |
| control + Menu               | wmfocus                                               |                 |
| Menu                         | ~/.config/rofi/scripts/launcher_t1.sh                 |                 |
| super + d                    | rofi -no-lazy-grab -show drun -modi run,drun,window   |                 |
| super + F5                   | uxterm -class "htop" -e htop                          |                 |
| super + alt + n              | kitty --class "notepad" /usr/local/bin/notepad.sh     |                 |
| F12                          | /usr/local/bin/search_web.sh                          |                 |
| shift + F12                  | /usr/local/bin/search_devdocs.sh                      |                 |
| XF86Search ; {d,w}           | {search_devdocs.sh,search_web.sh}                     |                 |
| alt + Tab                    | rofi -no-lazy-grab -show window -modi run,drun,window |                 |
| alt + shift + Return         | ~/.config/rofi/scripts/launcher_t4.sh                 |                 |
| alt + shift + KP_1           | tilda -g ~/.config/tilda/config_0                     |                 |
| alt + shift + KP_2           | tilda -g ~/.config/tilda/config_1                     |                 |
| XF86AudioLowerVolume         | amixer -c 0 set Master 3db-                           |                 |
| XF86AudioRaiseVolume         | amixer -c 0 set Master 3db+                           |                 |
| super + XF86AudioRaiseVolume | amixer -c 0 set Master toggle                         |                 |
| shift + XF86AudioLowerVolume | pactl -- set-sink-volume 0 -5%                        |                 |
| shift + XF86AudioRaiseVolume | pactl -- set-sink-volume 0 +5%                        |                 |
| super + XF86AudioLowerVolume | pactl -- set-sink-mute 0 toggle                       |                 |
| super + x                    | xkill                                                 |                 |
| super + End                  | pulsar                                                |                 |
| super + Home                 | google-chrome-stable %U                               |                 |
| super + shift + Home         | google-chrome-stable --new-window %U                  |                 |
| super + KP_Enter             | kitty -e ranger                                       |                 |
| super + shift + KP_Enter     | thunar                                                |                 |
| shift + Print                | teiler                                                |                 |
| super + Print                | simplescreenrecorder --start-hidden                   |                 |
| Print                        | sendmidi dev 'Midi Through Port-0' panic              |                 |
| XF86MonBrightnessDown        | brightnessctl -d intel_backlight s 10%-               |                 |
| XF86MonBrightnessUp          | brightnessctl -d intel_backlight s +10%               |                 |
| control + alt + End          | uxterm -class 'backup' -e sudo shutdown -h now        |                 |
| control + alt + Home         | uxterm -class 'backup' -e sudo shutdown -r now        |                 |

# i3
