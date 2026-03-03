#!/bin/bash

# Configuration
FLATPAK_ID="org.ryujinx.Ryujinx"

show_status() {
    echo "--- Current Status ---"
    # Checking for the 'network' share permission specifically
    if flatpak info --show-permissions $FLATPAK_ID | grep -q "network"; then
        echo "Flatpak Network: ✅ ENABLED"
    else
        echo "Flatpak Network: ❌ DISABLED"
    fi
    
    echo -n "Firewall Ports:  "
    active_ports=$(sudo firewall-cmd --list-ports)
    if [[ -z "$active_ports" ]]; then
        echo "None open"
    else
        echo "$active_ports"
    fi
    echo "----------------------"
}

case "$1" in
    on)
        echo "🔓 Enabling Ryujinx Online Mode..."
        # 1. Enable Flatpak Network
        flatpak override --user --share=network $FLATPAK_ID
        # 2. Open Temporary Firewall Ports (One by one to avoid errors)
        sudo firewall-cmd --add-port=30456/tcp
        sudo firewall-cmd --add-port=30456/udp
        sudo firewall-cmd --add-port=49152-65535/udp
        show_status
        ;;
    off)
        echo "🔒 Disabling Ryujinx Online Mode..."
        # 1. Disable Flatpak Network
        flatpak override --user --unshare=network $FLATPAK_ID
        # 2. Close Firewall Ports
        sudo firewall-cmd --remove-port=30456/tcp
        sudo firewall-cmd --remove-port=30456/udp
        sudo firewall-cmd --remove-port=49152-65535/udp
        show_status
        ;;
    status)
        show_status
        ;;
    *)
        echo "Usage: $0 {on|off|status}"
        exit 1
        ;;
esac
