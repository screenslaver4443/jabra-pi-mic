#!/bin/bash
. ./config.sh
setfont /usr/share/consolefonts/Lat15-TerminusBold32x16.psf.gz

trap 'setfont /usr/share/consolefonts/Lat15-TerminusBold14.psf.gz; exit' INT
while true; do
	clear	
	if systemctl --quiet is-active usb_arecord; then
		echo -e "\033[31mRecording\033[0m" # Red text
	else
		echo -e "\033[37mNot Recording\033[0m" # White text
	fi
	echo Wifi: $(iwgetid -r)
	echo RPi IP: $(hostname -I | awk '{print $1}')
	echo Destination: $SSHpath
	
	if [ -f /tmp/last_upload_status ]; then
    	status=$(cat /tmp/last_upload_status)
    	if [[ "$status" =~ ^success ]]; then
    	    # Check if status has a date/time after 'success'
    	    if [[ "$status" =~ ^success[[:space:]]+(.+) ]]; then
    	        datetime=$(echo "$status" | cut -d' ' -f2-)
    	        echo -e "\033[32mLast upload: Success at $datetime\033[0m"
    	    else
    	        echo -e "\033[32mLast upload: Success\033[0m"
    	    fi
		elif [ "$status" = "failed" ]; then
			echo -e "\033[31mLast upload: Failed\033[0m"
		else
			echo "Last upload: N/A"
		fi
	else
		echo "Last upload: N/A"
	fi	
	echo "Press Ctrl+C to exit"

	sleep 0.5
done

