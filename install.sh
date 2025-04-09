# /bin/bash
# Ask for the install directory
echo "Install Directory [/recscripts]:"
read INSTALL_DIR
if [ -z $INSTALL_DIR ]; then
    INSTALL_DIR="/recscripts"
fi

# Ask for the recordings directory
echo "Local Recording Storage Directory [/recordings]:"
read RECORDINGS_DIR
if [ -z $RECORDINGS_DIR ]; then
    RECORDINGS_DIR="/recordings"
fi

echo "Install 3.5LCD display driver [Y/n]:"
read LCD
if [ -z $LCD ]; then
    LCD="y"
fi

echo "Disable GUI [y/N]:"
read GUI
if [ -z $GUI ]; then
    GUI="n"
fi

if [ $GUI = "y" ]; then
    systemctl set-default multi-user.target
    echo "GUI disabled"
else
    systemctl set-default graphical.target
    echo "GUI enabled" 
fi


# Ask for the SSH remote recording storage directory
while true; do
echo "SSH target [username@hostname]:"
read SSH_TARGET
if [ -z $SSH_TARGET ]; then
    echo "SSH target cannot be empty"
else
    echo "SSH target is $SSH_TARGET"
    echo "is this correct? [y/n]"
    read yn
    if [ $yn = "y" ]; then
        break
    fi
fi
done

# Ask for the SSH remote recording storage directory
while true; do
echo "SSH target directory [/home/username/Desktop]:"
read SSH_TARGET_DIR
if [ -z $SSH_TARGET_DIR ]; then
    echo "SSH target directory cannot be empty"
else
    echo "SSH target directory is $SSH_TARGET_DIR"
    echo "is this correct? [y/n]"
    read yn
    if [ $yn = "y" ]; then
        break
    fi
fi
done
SSHpath="$SSH_TARGET:$SSH_TARGET_DIR"

# Create the recordings directory
mkdir -p $RECORDINGS_DIR

# Create the install directory
mkdir -p $INSTALL_DIR

# Adds Check Script
curl https://raw.githubusercontent.com/screenslaver4443/jabra-pi-mic/refs/heads/master/check_service.sh -o $INSTALL_DIR/check_service.sh
echo "$INSTALL_DIR/check_service.sh" >> ~/.bashrc #Add to end of bashrc
chmod +x $INSTALL_DIR/check_service.sh



# Adds USB Disconnect Script
curl https://raw.githubusercontent.com/screenslaver4443/jabra-pi-mic/refs/heads/master/usb_disconnect.sh -o $INSTALL_DIR/usb_disconnect.sh
chmod +x $INSTALL_DIR/usb_disconnect.sh

# add uninstall script
curl https://raw.githubusercontent.com/screenslaver4443/jabra-pi-mic/refs/heads/master/uninstall.sh -o $INSTALL_DIR/uninstall.sh
chmod +x $INSTALL_DIR/uninstall.sh

# add usb_arecord service
echo "[Unit]
Description=USB activated arecord
Wants=sound.target
After=sound.target

[Service]
Type=simple
ExecStart=/usr/bin/arecord -f cd -c 1 -D hw:3,0 -t wav $RECORDINGS_DIR/rec.wav
ExecStop=/bin/kill $MAINPID

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/usb_arecord.service
# Add usb_disconnect service
echo "[Unit]
Description=USB Disconnect Handler

[Service]
Type=oneshot
ExecStart=/$INSTALL_DIR/usb_disconnect.sh

[Install]
WantedBy=multi-user.target

" > /etc/systemd/system/usb_disconnect.service

#Get USB device ID
while true; do
    echo "Please connect the USB device and press enter"
    read " "
    USBID=$(lsusb | grep 'Jabra' | awk '{print $6}')
    if [ -z $USBID ]; then
        echo "No USB device found"
    else
        break
    fi
done
VENDOR_ID=$(echo $USBID | cut -d: -f1)
DEVICE_ID=$(echo $USBID | cut -d: -f2)
echo "ATTRS{idVendor}==\"$VENDOR_ID\", ATTRS{idProduct}==\"$DEVICE_ID\", ACTION==\"add\", RUN+=\"/usr/bin/systemctl start usb_arecord.service\"" > /etc/udev/rules.d/99-usb-arecord.rules
echo "ATTRS{idVendor}==\"$VENDOR_ID\", ATTRS{idProduct}==\"$DEVICE_ID\", ACTION==\"remove\", RUN+=\"/usr/bin/systemctl start usb_disconnect.service\"" > /etc/udev/rules.d/99-usb-disconnect.rules



# save locations to config file
echo "INSTALL_DIR=$INSTALL_DIR 
RECORDINGS_DIR=$RECORDINGS_DIR
SSHpath=$SSHpath
SSHtarget=$SSH_TARGET
GUI=$GUI" > $INSTALL_DIR/config.sh

# SSH Keygen
/bin/ssh-keygen -t rsa -b 4096 -C "usbrecorder" -f /root/.ssh/id_rsa -N ""
/bin/ssh-copy-id -i /root/.ssh/id_rsa $SSH_TARGET


# Install 3.5LCD display driver
if [ $LCD = "y" ]; then
    sudo rm -rf LCD-show
    git clone https://github.com/goodtft/LCD-show.git
    chmod -R 755 LCD-show
    cd LCD-show/
    sudo head -n-1 ./LCD35-show | bash 
    cd ..
    rm -rf LCD-show
fi