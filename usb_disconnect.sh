#!/bin/bash
# usb_disconnect.sh
. ./config.sh

exec > /tmp/usb_disconnect.log 2>&1
echo "started @ $(date) "
/bin/systemctl stop usb_arecord.service
if [ -f $RECORDINGS_DIR/rec.wav ]; then
    /bin/scp $RECORDINGS_DIR/rec.wav $SSHpath/rec.wav
    if [ $? -eq 0 ]; then
        echo "success $(date '+%Y-%m-%d %H:%M:%S')" > /tmp/last_upload_status
        rm $RECORDINGS_DIR/rec.wav
    else
        echo "fail $(date '+%Y-%m-%d %H:%M:%S')" > /tmp/last_upload_status
    fi
fi
echo "finished"