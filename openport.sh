#!/bin/bash

# Usage: ./openport.sh <port-number>

PORT=$1

if [ -z "$PORT" ]; then
    echo "Please specify a port number."
    exit 1
fi

# Check if the port is already open
if sudo iptables -L | grep -q "tcp dpt:$PORT"; then
    echo "Port $PORT is already open."
else
    # Add a rule to open the specified TCP port
    echo "Opening port $PORT..."
    sudo iptables -A INPUT -p tcp --dport $PORT -j ACCEPT
fi

# Create the /etc/iptables directory if it doesn't exist
if [ ! -d "/etc/iptables" ]; then
    echo "Creating /etc/iptables directory..."
    sudo mkdir /etc/iptables
fi

# Save the iptables rules
echo "Saving iptables rules..."
sudo sh -c "iptables-save > /etc/iptables/rules.v4"

# Install iptables-persistent for rules to persist across reboots
echo "Installing iptables-persistent..."
sudo apt-get install -y iptables-persistent

echo "Port $PORT is open and configured to persist across reboots."

