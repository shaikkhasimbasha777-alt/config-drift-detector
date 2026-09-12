#!/bin/bash

SERVERS_FILE="../servers.txt"
OUTPUT="../ssh-collected"

mkdir -p "$OUTPUT"

while read -r server_name host; do

    echo "====================================="
    echo "Collecting from: $server_name"
    echo "Host: $host"
    echo "====================================="

    # 1. SSH configuration
    ssh "$host" "cat /etc/ssh/sshd_config" \
        > "$OUTPUT/${server_name}_ssh_config"

    if [ $? -eq 0 ]; then
        echo "SSH config: SUCCESS"
    else
        echo "SSH config: FAILED"
    fi

    # 2. Network configuration
    ssh "$host" "sysctl net.ipv4.ip_forward \
        net.ipv4.conf.all.accept_redirects \
        net.ipv4.conf.all.send_redirects" \
        > "$OUTPUT/${server_name}_sysctl.conf"

    if [ $? -eq 0 ]; then
        echo "Sysctl config: SUCCESS"
    else
        echo "Sysctl config: FAILED"
    fi

    # 3. Firewall configuration
    ssh "$host" "sudo nft list ruleset 2>/dev/null || sudo iptables-save 2>/dev/null" \
        > "$OUTPUT/${server_name}_firewall.rules"

    if [ $? -eq 0 ]; then
        echo "Firewall config: SUCCESS"
    else
        echo "Firewall config: FAILED or unavailable"
    fi

    echo

done < "$SERVERS_FILE"

echo "====================================="
echo "Collection complete."
echo "====================================="
