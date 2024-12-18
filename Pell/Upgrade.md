## For Cosmosvisor
```
UPGRADE_NAME=v1.1.1
BINARY_URL=https://github.com/0xPellNetwork/network-config/releases/download/${UPGRADE_NAME}-ignite/pellcored-${UPGRADE_NAME}-linux-amd64

mkdir -p /root/.pellcored/cosmovisor/upgrades/$UPGRADE_NAME/bin
wget $BINARY_URL -O /root/.pellcored/cosmovisor/upgrades/$UPGRADE_NAME/bin/pellcored
chmod +x /root/.pellcored/cosmovisor/upgrades/$UPGRADE_NAME/bin/pellcored
```
## Run the Upgrade for Non-cosmosvisor
### 1. Install tmux (if not installed):
```
sudo apt update && sudo apt install tmux -y
```
### 2. Start a tmux Session:
```
tmux new -s upgrade
```
### 3. Download and Run the Script:
```
wget -O auto_upgrade.sh https://raw.githubusercontent.com/Sebatian1/Testnet/refs/heads/main/Pell/auto_upgrade.sh
chmod +x auto_upgrade.sh
./auto_upgrade.sh
```
_Detach Session: Press Ctrl + B, then D._
### Reattach to the Session:
```
tmux attach -t upgrade
```
### Kill the Session (if needed):
```
tmux kill-session -t upgrade
```
