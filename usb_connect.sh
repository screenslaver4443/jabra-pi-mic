#! /bin/bash
# usb_connect.sh

exec > /tmp/usb_connect.log 2>&1
echo "started @ $(date)"
cd /recordings
/bin/arecord -f cd rec.wav &
echo $! > /tmp/usb_process.pid
echo "finished"
