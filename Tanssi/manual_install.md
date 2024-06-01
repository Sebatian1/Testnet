# Manual node setup

## Recommended Hardware Requirements 

|   SPEC	    |       Block Producer      |
|-------------|---------------------------|    
|   **CPU**   |         8 Cores           |
|   **RAM**   |          32 GB            |
| **Storage** |          1 TB SSD         |
| **NETWORK** |         500 Mbps          |

### Update system and install build tools
```
apt update && apt upgrade -y
apt install curl iptables build-essential git wget jq make gcc nano tmux htop nvme-cli pkg-config libssl-dev libleveldb-dev libgmp3-dev tar clang bsdmainutils ncdu unzip llvm libudev-dev make protobuf-compiler -y
```
### Download the Latest Release
```
wget https://github.com/moondance-labs/tanssi/releases/download/v0.6.3/tanssi-node && \
chmod +x ./tanssi-node
```
### Creat new wallet
```
./tanssi-node key generate -w24
```
### Creat tanssi-data
```
adduser tanssi_service --system --no-create-home
mkdir /var/lib/tanssi-data
sudo chown -R tanssi_service /var/lib/tanssi-data
mv ./tanssi-node /var/lib/tanssi-data
```
### Create the Systemd Service Configuration File
(**Replace** _NODE_NAME_)
Creat tanssi.service & save file
```
sudo nano /etc/systemd/system/tanssi.service
```
```
[Unit]
Description="Tanssi systemd service"
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
Restart=on-failure
RestartSec=10
User=tanssi_service
SyslogIdentifier=tanssi
SyslogFacility=local7
KillSignal=SIGHUP
ExecStart=/var/lib/tanssi-data/tanssi-node \
--chain=dancebox \
--name=NODE_NAME \
--sync=warp \
--base-path=/var/lib/tanssi-data/para \
--state-pruning=2000 \
--blocks-pruning=2000 \
--collator \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0' \
--database paritydb \
-- \
--name=NODE_NAME \
--base-path=/var/lib/tanssi-data/container \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0' \
-- \
--chain=westend_moonbase_relay_testnet \
--name=NODE_NAME \
--sync=fast \
--base-path=/var/lib/tanssi-data/relay \
--state-pruning=2000 \
--blocks-pruning=2000 \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0' \
--database paritydb \

[Install]
WantedBy=multi-user.target
```
```
systemctl enable tanssi.service
systemctl daemon-reload
systemctl restart tanssi.service && journalctl -f -u tanssi.service
```

### Generate Session Keys
```
curl http://127.0.0.1:9944 -H \
"Content-Type:application/json;charset=utf-8" -d \
  '{
    "jsonrpc":"2.0",
    "id":1,
    "method":"author_rotateKeys",
    "params": []
  }'
```
