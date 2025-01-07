## For Cosmovisor
```
UPGRADE_NAME=v1.1.5
BINARY_URL=https://github.com/0xPellNetwork/network-config/releases/download/${UPGRADE_NAME}/pellcored-${UPGRADE_NAME}-linux-amd64

mkdir -p /root/.pellcored/cosmovisor/upgrades/$UPGRADE_NAME/bin
wget $BINARY_URL -O /root/.pellcored/cosmovisor/upgrades/$UPGRADE_NAME/bin/pellcored
chmod +x /root/.pellcored/cosmovisor/upgrades/$UPGRADE_NAME/bin/pellcored
```
## For Non-cosmovisor
```
sudo systemctl stop pellcored.service
cd $HOME
wget -O pellcored https://github.com/0xPellNetwork/network-config/releases/download/v1.1.5/pellcored-v1.1.5-linux-amd64
chmod +x pellcored
sudo mv $HOME/pellcored $(which pellcored)
sudo systemctl restart pellcored.service
sudo journalctl -u pellcored.service -f --no-hostname -o cat
```
