#!/bin/bash
# Open the ports
sudo firewall-cmd --zone=public --add-port=10000-60000/udp
sudo firewall-cmd --zone=public --add-port=27312/tcp

# Run the emulator
flatpak run org.ppsspp.PPSSPP

# When emulator closes, remove the rules
sudo firewall-cmd --zone=public --remove-port=10000-60000/udp
sudo firewall-cmd --zone=public --remove-port=27312/tcp
