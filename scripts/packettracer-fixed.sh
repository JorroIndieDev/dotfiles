#!/bin/bash
export LD_PRELOAD="/usr/lib64/libssl.so.3:/usr/lib64/libcrypto.so.3"
# Use the path whereis confirmed
exec /usr/local/bin/packettracer "$@"
