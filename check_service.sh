#!/bin/bash
setfont /usr/share/consolefonts/Lat15-TerminusBold32x16.psf.gz
while true; do
	clear	
	if systemctl --quiet is-active usb_arecord; then
		echo Recording
	else
		echo Not Recording
	fi
	echo Wifi: $(iwgetid -r)
	
	sleep 0.5
done

