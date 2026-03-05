#!/bin/bash

echo "--- [1] Kernel Serial Events (dmesg) ---"
# Insurance: Show the last 5 tty-related kernel messages
# This tells you the BRAND and CHIP of what you just plugged in
sudo dmesg | grep -iE "tty|usb" | tail -n 5
echo "----------------------------------------"

# 2. Identify active device files
USB_PORTS=$(ls /dev/ttyUSB* /dev/ttyACM* 2>/dev/null)

if [ -z "$USB_PORTS" ]; then
    echo "No active USB Serial device files found in /dev/."
    echo "Check dmesg output above for errors (e.g., 'pwr fail' or 'disconnected')."
    echo ""
    read -p "Press [Enter] to close..."
    exit 1
fi

echo "--- [2] Available Device Files ---"
echo "$USB_PORTS"
echo "----------------------------------------"

# 3. Best Guess Selection
PRIMARY_PORT=$(echo "$USB_PORTS" | head -n 1)
echo "🔍 Suggesting Connection: $PRIMARY_PORT"

# setserial verification as per the blog post
echo -n "Hardware Status: "
sudo setserial -g "$PRIMARY_PORT"
echo "----------------------------------------"

# 4. Interactive Connection
read -p "Connect to $PRIMARY_PORT now? (y/n): " confirm

if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    read -p "Enter baud rate [9600]: " BAUD
    BAUD=${BAUD:-9600}
    
    echo "Launching screen session..."
    echo "COMMAND: sudo screen $PRIMARY_PORT $BAUD"
    echo "----------------------------------------"
    echo "EXIT TIPS:"
    echo "1. Press 'Ctrl+A'"
    echo "2. Press 'K' (Kill)"
    echo "3. Press 'Y' (Yes)"
    sleep 2
    
    sudo screen "$PRIMARY_PORT" "$BAUD"
else
    echo "Exiting..."
    read -p "Press [Enter] to close window."
fi