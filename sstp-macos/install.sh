#!/bin/bash

# Download the files
sudo wget -O /usr/local/bin/sstp-connect https://raw.githubusercontent.com/stsvinc/get/main/sstp-macos/sstp-connect.sh
sudo wget -O /usr/local/bin/sstp-disconnect https://raw.githubusercontent.com/stsvinc/get/main/sstp-macos/sstp-disconnect.sh

# Make the file executable
sudo chmod +x /usr/local/bin/sstp-connect
sudo chmod +x /usr/local/bin/sstp-disconnect

sudo ln -s /usr/local/bin/sstp-connect /usr/bin/sstp-connect
sudo ln -s /usr/local/bin/sstp-disconnect /usr/bin/sstp-disconnect

echo "Installation complete"