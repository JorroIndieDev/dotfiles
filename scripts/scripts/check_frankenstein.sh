#!/bin/bash
# A temporary file to remember the last state
STATE_FILE="/tmp/frankenstein_state"
SERVER_IP="192.168.1.110"

# Check if server is alive
if ping -c 1 $SERVER_IP > /dev/null; then
    # If it was offline before, and now it's online...
    if [ ! -f $STATE_FILE ]; then
        notify-send "Frankenstein Online" "Storage is ready for mounting."
        touch $STATE_FILE
    fi
    echo '{"text": "", "class": "online", "tooltip": "Frankenstein Online"}'
else
    # If it was online before, and now it's offline...
    if [ -f $STATE_FILE ]; then
        notify-send "Frankenstein Offline" "Server has disconnected."
        rm $STATE_FILE
    fi
    echo '{"text": "", "class": "offline", "tooltip": "Frankenstein Offline"}'
fi
