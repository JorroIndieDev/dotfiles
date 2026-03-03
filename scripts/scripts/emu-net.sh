#!/bin/bash

# Configuration
RYU_ID="io.github.ryubing.Ryujinx"
PSP_ID="org.ppsspp.PPSSPP"

# Define the exact strings firewalld expects
RYU_P1="30456/tcp"
RYU_P2="30456/udp"
RYU_RANGE="49152-65535/udp"

PSP_P1="27312/tcp"
PSP_RANGE="10000-60000/udp"

PS3_P1="3074/tcp"
PS3_P2="3478-3479/udp"
PS3_P3="3658/udp"
PS3_P4="10070-10080/tcp"

show_status() {
    # 1. Get the RAW list from the firewall first
    echo -e "\n🔍 [ FIREWALLD VERIFIED OPEN PORTS ]"
    RAW_PORTS=$(sudo firewall-cmd --list-ports)
    if [[ -z "$RAW_PORTS" ]]; then
        echo "   (No ports are currently open in the active zone)"
    else
        echo "   $RAW_PORTS"
    fi

    # 2. Status verification logic
    echo -e "\n================ [ EMULATOR STATUS ] ================"
    
    echo "RYUJINX:"
    [[ "$RAW_PORTS" == *"$RYU_P1"* ]] && [[ "$RAW_PORTS" == *"$RYU_P2"* ]] && echo -ne "  - Master (30456): ✅ " || echo -ne "  - Master (30456): ❌ "
    [[ "$RAW_PORTS" == *"$RYU_RANGE"* ]] && echo " | P2P Range: ✅" || echo " | P2P Range: ❌"

    echo "PPSSPP:"
    [[ "$RAW_PORTS" == *"$PSP_P1"* ]] && echo -ne "  - Server (27312): ✅ " || echo -ne "  - Server (27312): ❌ "
    [[ "$RAW_PORTS" == *"$PSP_RANGE"* ]] && echo " | P2P Range: ✅" || echo " | P2P Range: ❌"

    echo "RPCS3:"
    [[ "$RAW_PORTS" == *"$PS3_P1"* ]] && echo -ne "  - Base (3074): ✅ " || echo -ne "  - Base (3074): ❌ "
    [[ "$RAW_PORTS" == *"$PS3_P4"* ]] && echo " | PSN Range: ✅" || echo " | PSN Range: ❌"

    echo -e "\nSANDBOX PERMISSIONS:"
    flatpak info --show-permissions $RYU_ID 2>/dev/null | grep -q "network" && echo "  - Ryujinx: ✅" || echo "  - Ryujinx: 🔒"
    flatpak info --show-permissions $PSP_ID 2>/dev/null | grep -q "network" && echo "  - PPSSPP:  ✅" || echo "  - PPSSPP:  🔒"
    echo -e "=====================================================\n"
}

case "${1,,}" in
    on|enable)
        echo "🚀 Opening Emulation Ports..."
        flatpak override --user --share=network $RYU_ID
        flatpak override --user --share=network $PSP_ID
        
        # Adding ports individually to ensure firewalld registers each string correctly
        for p in $RYU_P1 $RYU_P2 $RYU_RANGE $PSP_P1 $PSP_RANGE $PS3_P1 $PS3_P2 $PS3_P3 $PS3_P4; do
            sudo firewall-cmd --add-port="$p" --quiet
        done
        show_status
        ;;
    off|disable)
        echo "🔒 Closing Emulation Ports..."
        flatpak override --user --unshare=network $RYU_ID
        flatpak override --user --unshare=network $PSP_ID
        
        for p in $RYU_P1 $RYU_P2 $RYU_RANGE $PSP_P1 $PSP_RANGE $PS3_P1 $PS3_P2 $PS3_P3 $PS3_P4; do
            sudo firewall-cmd --remove-port="$p" --quiet
        done
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
