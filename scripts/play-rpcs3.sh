#!/bin/bash

# 1. Open RPCS3 specific ports
# We include the 10000-60000 range just in case for P2P games
sudo firewall-cmd --zone=public --add-port=3074/tcp --add-port=3478-3479/udp --add-port=3658/udp --add-port=10070-10080/tcp --add-port=10000-60000/udp

# 2. Run RPCS3 Flatpak
/home/captain/Applications/rpcs3-v0.0.39-18803-a6b5c7e7_linux64.AppImage

# 3. Clean up Firewall on Exit
sudo firewall-cmd --zone=public --remove-port=3074/tcp --remove-port=3478-3479/udp --remove-port=3658/udp --remove-port=10070-10080/tcp --remove-port=10000-60000/udp
