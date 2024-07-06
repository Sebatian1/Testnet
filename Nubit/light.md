### Hardware Requirements

|   SPEC      |       Recommend          |
| :---------: | :-----------------------:|
|   **CPU**   |        1 Cores           |
|   **RAM**   |        500 Mb Ram        |
| **Storage** |        40 GB SSD         |

## Systemd
### Create the systemd service file:
```
sudo tee /etc/systemd/system/nulight.service > /dev/null <<EOF
[Unit]
Description=Nubit Light Service
After=network.target

[Service]
Type=simple
Environment="HOME=/root"
ExecStart=/bin/bash -c 'curl -sL1 https://nubit.sh | bash'
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable nulight.service
```
### Start service & check logs
```
sudo systemctl start nulight.service && journalctl -u nulight.service -f
```
_Save MNEMONIC, PUBKEY and AUTHKEY after run service_

### List all keys:
```
$HOME/nubit-node/bin/nkey list --p2p.network nubit-alphatestnet-1 --node.type light
```
### Import the new key
```
$HOME/nubit-node/bin/nkey add my_nubit_key --recover --keyring-backend test --node.type light --p2p.network nubit-alphatestnet-1
```
### Delete the selected key
```
$HOME/nubit-node/bin/nkey delete my_nubit_key -f --node.type light --p2p.network nubit-alphatestnet-1
```
### Export seed phrase
```
cat $HOME/nubit-node/mnemonic.txt
```
### Uninstall nubit-node
```
sudo systemctl stop nulight.service
sudo systemctl disable nulight.service
sudo systemctl daemon-reload
rm /etc/systemd/system/nulight.service
rm -rf $HOME/nubit-node
rm -rf $HOME/.nubit-light-nubit-alphatestnet-1
```
### Connect wallet & claim point
https://alpha.nubit.org/
