#!/bin/bash
# usb_disconnect.sh
. ./config.sh

exec > /tmp/usb_disconnect.log 2>&1
echo "started @ $(date) "
/bin/systemctl stop usb_arecord.service
if [ -f $RECORDINGS_DIR/rec.wav ]; then
	/bin/scp $RECORDINGS_DIR/rec.wav $SSHpath/rec.wav
	rm $RECORDINGS_DIR/rec.wav
fi
echo "finished"