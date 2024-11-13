# /bin/bash

# Load configuration
source ./config.sh

# Remove check_service.sh from .bashrc
sed -i '/check_service.sh/d' ~/.bashrc

# Remove created directories
rm -rf $INSTALL_DIR
rm -rf $RECORDINGS_DIR

# Remove systemd services
systemctl stop usb_arecord.service
systemctl disable usb_arecord.service
rm /etc/systemd/system/usb_arecord.service

systemctl stop usb_disconnect.service
systemctl disable usb_disconnect.service
rm /etc/systemd/system/usb_disconnect.service

# Remove udev rules
rm /etc/udev/rules.d/99-usb-arecord.rules
rm /etc/udev/rules.d/99-usb-disconnect.rules

# Remove SSH key
rm /root/.ssh/id_rsa
rm /root/.ssh/id_rsa.pub

# Restore GUI if it was disabled
if [ $GUI = "y" ]; then
    systemctl set-default graphical.target
    echo "GUI restored"
fi

echo "Uninstallation complete."