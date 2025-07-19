#!/bin/bash
setfont /usr/share/consolefonts/Lat15-TerminusBold32x16.psf.gz

trap 'setfont /usr/share/consolefonts/Lat15-TerminusBold14.psf.gz; exit' INT
while true; do
	clear	
	if systemctl --quiet is-active usb_arecord; then
		echo -ne "\033]11;#ff0000\007" # Set background to red
		echo Recording
	else
		echo -ne "\033]11;#000000\007" # Reset background to black
		echo Not Recording
	fi
	echo Wifi: $(iwgetid -r)
	echo IP: $(hostname -I | awk '{print $1}')
	
	sleep 0.5
done

