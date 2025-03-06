# jabra-pi-mic

This repository contains scripts and configuration files to set up a Raspberry Pi to automatically start recording audio when a USB microphone is connected and stop recording when the microphone is disconnected. The recorded audio file is then transferred to a specified remote location using SCP.

## Features

- Automatically starts recording when a USB microphone is connected.
- Stops recording and transfers the audio file to a remote server when the microphone is disconnected.
- Configurable installation and recording directories.
- Option to disable the GUI for headless operation.
- Includes an uninstall script to remove all installed components.
- Includes a script that displays the current status (recording or not and network connectivity status)
- Has option to install a display driver for this monitor: [PlaceHolder]

## Requirements

- Raspberry Pi with Raspbian OS installed.
- USB microphone.
- SSH access to the remote server for SCP file transfer.
- Git
- Curl

## Installation

1. Run the following CURL command on your raspberry pi

```sh
curl -s -L https://raw.githubusercontent.com/screenslaver4443/jabra-pi-mic/refs/heads/master/install.sh | bash
```

2. Follow prompts while installing.

## Usage

- Connect the USB microphone to the Raspberry Pi. The recording will start automatically.
- Disconnect the USB microphone to stop the recording and transfer the audio file to the specified remote server.
- If connected to display and device is set to login automatically, screen will display if the device is recording and if its connected to a network.
  - Ctrl+c can be used to escape into Terminal.

## Uninstallation

To uninstall and remove all installed components, run the uninstall script:

```sh
sudo ./uninstall.sh
```
