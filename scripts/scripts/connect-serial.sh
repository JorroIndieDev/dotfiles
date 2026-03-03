#!/bin/bash

echo -e "\n--- Recent Serial Hardware Events (dmesg) ---\n"
# Shows the last 5 serial-related events to help you identify the hardware
sudo dmesg | grep -i tty | tail -n 5
echo -e "------------------------------------------------------\n"

# Now show the actual active files
# 1. Identify all USB serial devices
USB_PORTS=$(ls /dev/ttyUSB* /dev/ttyACM* 2>/dev/null)

if [ -z "$USB_PORTS" ]; then
    echo "No USB-to-Serial devices found."
    exit 1
fi

echo "--- Available USB Serial Ports ---"
echo "$USB_PORTS"
echo "----------------------------------"

# 2. Pick the first one as the "best guess"
PRIMARY_PORT=$(echo "$USB_PORTS" | head -n 1)

echo "The script has identified '$PRIMARY_PORT' as the primary connection."
# Verify with setserial as per the blog post
echo "Hardware verification:"
setserial -g "$PRIMARY_PORT"

# 3. Ask for confirmation
read -p "Would you like to connect to $PRIMARY_PORT? (y/n): " confirm

if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    read -p "Enter baud rate [115200]: " BAUD
    BAUD=${BAUD:-115200}
    
    echo "Connecting to $PRIMARY_PORT at $BAUD..."
    echo "Tip: Press Ctrl+A then K, then Y to exit screen."
    sleep 1
    
    sudo screen "$PRIMARY_PORT" "$BAUD"
else
    echo "Connection cancelled."
fi