#!/bin/bash

selector_bemenu() { # (prompt)
	bemenu -f -i -w -l "$2" -c -M 400 -B 2 -p "$1" --fixed-height --counter always \
		--cw 2 \
		--fn 'Monospace 14' \
		--bdr '#3b3b3b' \
		--tb '#d81860' \
		--tf '#121212' 
}

selector_rofi() { # (prompt)
	rofi -dmenu -theme gruvbox-dark-hard -p "$1" -l "$2" \
		-theme-str 'listview{fixed-height:false;}'
}

xfconf-query -c xfce4-keyboard-shortcuts -l -v \
	| grep '/commands/custom/' \
	| grep -v '/override' \
	| cut -d '/' -f 4- \
	| selector_rofi 'Maps' 12 \
	| cut -d ' ' -f 1 \
	| sed -e 's/>/+/g' -e 's/<//g' -e 's/Primary/Control/g' -e 's/slash/61/g' \
	| xargs -r xdotool key --clearmodifiers
