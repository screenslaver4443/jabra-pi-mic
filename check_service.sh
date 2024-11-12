#!/bin/bash

while true; do
	if systemctl --quiet is-active usb_arecord; then
		echo "Recording"
	else
		echo "Not Recording"
	fi
	sleep 0.5
	clear	
done

