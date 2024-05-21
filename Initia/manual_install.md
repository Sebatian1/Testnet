|      Chain ID       |  Port  |  Version  |
|---------------------|--------|-----------|
|       initation-1   |  119   |   v0.2.15 |


**API:** https://api-initia.sebatian.org/

**RPC:** https://rpc-initia.sebatian.org/

**GRPC:** https://grpc-initia.sebatian.org/


# Manual node setup
Here you have to put name of your moniker (validator) that will be visible in explorer
```
MONIKER="Your Moniker"
```
## Update and install packages for compiling
```
sudo apt -q update
sudo apt -qy install curl git jq lz4 build-essential
sudo apt -qy upgrade
```
### Install go
```
cd $HOME && \
ver="1.22.2" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile && \
source ~/.bash_profile && \
go version
```
## Build binary
```
cd $HOME
rm -rf initia
git clone https://github.com/initia-labs/initia.git
cd initia
git checkout v0.2.15
make install
```
## Initialize Node
```
initiad init "$MONIKER" --chain-id initation-1
initiad config chain-id initation-1 (ko lam)
sed -i \
  -e 's|^keyring-backend *=.*|keyring-backend = "test"|' \
  -e 's|^node *=.*|node = "tcp://localhost:11957"|' \
  $HOME/.initia/config/client.toml
SEEDS=""
PEERS=$(curl -s https://raw.githubusercontent.com/Sebatian1/Cosmos/main/Initia/Peers.txt)
sed -i 's|^seeds *=.*|seeds = "'$SEEDS'"|; s|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.initia/config/config.toml
```
## Download Genesis & Addrbook
```
wget -O $HOME/.initia/config/addrbook.json https://rpc-initia-testnet.trusted-point.com/addrbook.json
curl -Ls https://initia.s3.ap-southeast-1.amazonaws.com/initiation-1/genesis.json > \
         $HOME/.initia/config/genesis.json
```
## Configure
```
sed -i 's|^pruning *=.*|pruning = "custom"|g' $HOME/.initia/config/app.toml
sed -i 's|^pruning-keep-recent  *=.*|pruning-keep-recent = "100"|g' $HOME/.initia/config/app.toml
sed -i 's|^pruning-interval *=.*|pruning-interval = "10"|g' $HOME/.initia/config/app.toml
sed -i 's|^snapshot-interval *=.*|snapshot-interval = 0|g' $HOME/.initia/config/app.toml

sed -i -e 's/external_address = \"\"/external_address = \"'$(curl httpbin.org/ip | jq -r .origin)':11956\"/g' ~/.initia/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.15uinit,0.01uusdc\"|" $HOME/.initia/config/app.toml
sed -i 's|^prometheus *=.*|prometheus = true|' $HOME/.initia/config/config.toml

```
## Custom Port
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:11958\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:11957\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:11960\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:11956\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":11966\"%" $HOME/.initia/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:11917\"%; s%^address = \":8080\"%address = \":11980\"%; s%^address = \"localhost:9090\"%address = \"0.0.0.0:11990\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:11991\"%; s%:8545%:11945%; s%:8546%:11946%; s%:6065%:11965%" $HOME/.initia/config/app.toml
```
## Creat systemd service
```
sudo tee /etc/systemd/system/initia.service > /dev/null << EOF
[Unit]
Description=initia node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which initiad) start
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable initia
```
## Start Node
```
sudo systemctl restart initia && journalctl -fu initia -o cat
```
# Set up Oracle
This guide is only for validator nodes
## Clone the Repository and build binaries
```
# Clone repository
cd $HOME
rm -rf slinky
git clone https://github.com/skip-mev/slinky.git
cd slinky
git checkout v0.4.3

# Build binaries
make build

# Move binary to local bin
mv build/slinky /usr/local/bin/
rm -rf build
```
## Creat systemd service
```
sudo tee /etc/systemd/system/slinky.service > /dev/null <<EOF
[Unit]
Description=Initia Slinky Oracle
After=network-online.target

[Service]
User=$USER
ExecStart=$(which slinky) --oracle-config-path $HOME/slinky/config/core/oracle.json --market-map-endpoint 127.0.0.1:11990
Restart=on-failure
RestartSec=30
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable slinky.service
```
## Validating Prices
### make run-oracle-client
```
~/.initia/app.toml
```
```
###############################################################################
###                                  Oracle                                 ###
###############################################################################
[oracle]
# Enabled indicates whether the oracle is enabled.
enabled = "true"

# Oracle Address is the URL of the out of process oracle sidecar. This is used to
# connect to the oracle sidecar when the application boots up. Note that the address
# can be modified at any point, but will only take effect after the application is
# restarted. This can be the address of an oracle container running on the same
# machine or a remote machine.
oracle_address = "127.0.0.1:8080"

# Client Timeout is the time that the client is willing to wait for responses from 
# the oracle before timing out.
client_timeout = "300ms"

# MetricsEnabled determines whether oracle metrics are enabled. Specifically
# this enables instrumentation of the oracle client and the interaction between
# the oracle and the app.
metrics_enabled = "false"
```
### run-oracle
```
sudo systemctl start slinky.service
journalctl -fu slinky --no-hostname
```
