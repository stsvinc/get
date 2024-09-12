#!/bin/bash

# Function to check if clipboard contains the config
get_clipboard_config() {
    # Retrieve clipboard content
    CLIPBOARD_CONTENT=$(pbpaste)

    # Check if clipboard contains valid content (assuming config starts with VPN_USER=)
    if [[ "$CLIPBOARD_CONTENT" == VPN_USER=* ]]; then
        echo "Configuration found in clipboard"
        eval "$CLIPBOARD_CONTENT"
        return 0
    else
        return 1
    fi
}

# Load configuration from clipboard or file
if get_clipboard_config; then
    echo "Using clipboard configuration"
else
    # If no config in clipboard, check if a config file is passed as a parameter
    if [ -z "$1" ]; then
        echo "Usage: $0 <config-file> (or place config in clipboard)"
        exit 1
    fi

    CONFIG_FILE="$1"

    # Check if the config file exists
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "Config file not found: $CONFIG_FILE"
        exit 1
    fi

    # Source the config file
    source "$CONFIG_FILE"
fi

# Get the directory where the script is located
SCRIPT_DIR=$(dirname "$0")

# Define the paths for the PID and certificate files in the script's directory
#PID_FILE="$SCRIPT_DIR/.sstpc_vpn.pid"
#CERT_FILE="$SCRIPT_DIR/.certificate.crt"
PID_FILE="/tmp/sstpc_vpn.pid"
CERT_FILE="/tmp/sstpc_certificate.crt"

# Function to create the certificate file
create_certificate() {
    echo "$CERTIFICATE_CONTENT" > "$CERT_FILE"
    echo "Certificate created at: $CERT_FILE"
}

# Function to clean up the PID and certificate files
cleanup() {
    if [ -f "$PID_FILE" ]; then
        OLD_PID=$(cat "$PID_FILE")
        if ps -p $OLD_PID > /dev/null 2>&1; then
            echo "Killing the old VPN process with PID: $OLD_PID"
            sudo kill $OLD_PID
        fi
        rm -f "$PID_FILE"
    fi

    if [ -f "$CERT_FILE" ]; then
        echo "Deleting certificate file: $CERT_FILE"
        rm -f "$CERT_FILE"
    fi
}

# Check for existing PID and clean up if necessary
cleanup

# Create a new certificate file
create_certificate

# Start a new SSTP connection in the background
sudo sstpc --ca-cert "$CERT_FILE" --user $VPN_USER --password $VPN_PASS $VPN_HOSTP require-mschap-v2 noauth &

# Capture the new process ID of the SSTP connection
VPN_PID=$!
echo "New VPN process started with PID: $VPN_PID"

# Save the new PID to the PID file
echo $VPN_PID > "$PID_FILE"

# Sleep for a few seconds to ensure SSTP connection is established
sleep 5

# Add the specific route
sudo route add -net $VPN_ROUTE -interface ppp0

# Print a success message
echo "VPN connected and route added. New SSTP PID: $VPN_PID"