#!/bin/bash

UPGRADE_NAME=v1.1.1
BINARY_URL="https://github.com/0xPellNetwork/network-config/releases/download/${UPGRADE_NAME}-ignite/pellcored-${UPGRADE_NAME}-linux-amd64"
BINARY_PATH="/usr/local/bin/pellcored"
TARGET_BLOCK=185000
NODE_RPC="http://34.87.47.193:26657"

get_current_block() {
    curl -s "$NODE_RPC/status" | jq -r '.result.sync_info.latest_block_height'
}

download_binary() {
    wget -q $BINARY_URL -O /tmp/pellcored
    chmod +x /tmp/pellcored
}

replace_binary() {
    cp $BINARY_PATH "${BINARY_PATH}-backup-$(date +%F-%T)"
    mv /tmp/pellcored $BINARY_PATH
}

restart_service() {
    sudo systemctl restart pell
}

while true; do
    current_block=$(get_current_block)
    if [[ "$current_block" -ge "$TARGET_BLOCK" ]]; then
        download_binary
        replace_binary
        restart_service
        echo "Upgraded at block $current_block."
        break
    else
        echo "Current block: $current_block. Waiting..."
    fi
    sleep 10
done
