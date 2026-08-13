#!/usr/bin/env bash

# Check if the script is running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Relaunching with sudo..."
    # Relaunch the script with sudo and the absolute path
    exec sudo bash "$0" "$@"
    # The 'exec' command replaces the current shell process with the new one
fi

# Step 1: Authenticate via SAML
eval $(gp-saml-gui --gateway vpn-hsv-32.adtran.com)

# Step 2: Connect
echo "$COOKIE" | sudo openconnect --protocol=gp \
  --passwd-on-stdin \
  --user="$USER" \
  --usergroup=gateway:prelogin-cookie \
  --os=linux-64 \
  --disable-ipv6 \
  vpn-hsv-32.adtran.com
