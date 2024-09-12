!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR=$(dirname "$0")

# Define the paths for the PID and certificate files in the script's directory
#PID_FILE="$SCRIPT_DIR/.sstpc_vpn.pid"
#CERT_FILE="$SCRIPT_DIR/.certificate.crt"
PID_FILE="/tmp/sstpc_vpn.pid"
CERT_FILE="/tmp/sstpc_certificate.crt"


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

# Print a success message
echo "VPN disconnected."
