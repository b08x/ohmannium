# fix for screen readers

if grep -Fq 'accessibility=' /proc/cmdline &> /dev/null; then
    setopt SINGLE_LINE_ZLE
	clear
	echo -e "\nWelcome to [38;2;23;147;209mArchLabs Linux[0m\n\nTo begin an installation run [35minstaller[0m, for more options see [35minstaller -h[0m\n"
else
	[ -z "$DISPLAY" ] && [ $XDG_VTNR -eq 1 ] && sleep 2 && startx
fi
