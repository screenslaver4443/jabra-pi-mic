#!/bin/bash

# Check for root (sudo) privileges
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root. Please use sudo."
    exit 1
fi

REPO_URL="https://github.com/screenslaver4443/jabra-pi-mic"
TMP_DIR=$(mktemp -d)

echo "Downloading latest scripts from $REPO_URL..."

# Clone the repo to a temporary directory
git clone --depth 1 "$REPO_URL" "$TMP_DIR"

if [ $? -ne 0 ]; then
    echo "Failed to clone repository."
    rm -rf "$TMP_DIR"
    exit 1
fi

# List of files to update (add or remove as needed)
FILES_TO_UPDATE=("uninstall.sh" "check_service.sh" "update.sh" "usb_disconnect.sh")

for file in "${FILES_TO_UPDATE[@]}"; do
    if [ -f "$TMP_DIR/$file" ]; then
        cp "$TMP_DIR/$file" ./
        echo "Updated $file"
    else
        echo "Warning: $file not found in repository."
    fi
done

rm -rf "$TMP_DIR"
echo "Update complete."

echo "Updating system packages..."
apt update && apt upgrade -y

if [ $? -eq 0 ]; then
    echo "System packages updated successfully. The system will now reboot."
    reboot
else
    echo "Package update failed. Please check for errors. System will not reboot."
fi
