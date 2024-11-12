#!/bin/bash
# usb_disconnect.sh

exec > /tmp/usb_disconnect.log 2>&1
echo "started @ $(date) "
/bin/systemctl stop usb_arecord.service
if [ -f /recordings/rec.wav ]; then
	/bin/scp /recordings/rec.wav nikolai@mac:~/Desktop
	rm /recordings/rec.wav
fi
echo "finished"
