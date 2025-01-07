```
sudo systemctl stop pellcored.service
cd $HOME
wget -O pellcored https://github.com/0xPellNetwork/network-config/releases/download/v1.1.5/pellcored-v1.1.5-linux-amd64
chmod +x pellcored
sudo mv $HOME/pellcored $(which pellcored)
sudo systemctl restart pellcored.service
sudo journalctl -u pellcored.service -f --no-hostname -o cat
```
