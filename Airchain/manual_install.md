|      Chain ID       |  Port  |  Version  |
|---------------------|--------|-----------|
|junction |  130   |   v0.1.0   |


**API:** https://apitt-airchain.sebatian.org/

**RPC:** https://rpctt-airchain.sebatian.org/

**GRPC:** grpctt-airchain.sebatian.org:13090

**Explorer:** https://explorer.sebatian.org/airchains/

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
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.21.10.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
```
## Build binary
```
cd $HOME && mkdir -p go/bin/
wget -O junctiond https://github.com/airchains-network/junction/releases/download/v0.3.1/junctiond-linux-amd64
chmod +x junctiond
mv junctiond $HOME/go/bin/
```
## Cosmovisor Setup
```
sudo tee /etc/systemd/system/junction.service > /dev/null <<EOF
[Unit]
Description=junction
After=network-online.target

[Service]
User=$USER
ExecStart=$(which junctiond) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable junction
```
## Initialize Node
```
junctiond init $MONIKER --chain-id varanasi-1
sed -i -e "s|^node *=.*|node = \"tcp://localhost:13657\"|" $HOME/.junctiond/config/client.toml
```
## Download Genesis & Addrbook
```
wget -O $HOME/.junctiond/config/genesis.json https://server-7.itrocket.net/testnet/airchains_v/genesis.json
wget -O $HOME/.junctiond/config/addrbook.json  https://server-7.itrocket.net/testnet/airchains_v/addrbook.json
```
## Configure
```
# set seeds and peers
peers="48887cbb310bb854d7f9da8d5687cbfca02b9968@35.200.245.190:26656,2d1ea4833843cc1433e3c44e69e297f357d2d8bd@5.78.118.106:26656,de2e7251667dee5de5eed98e54a58749fadd23d8@34.22.237.85:26656,1918bd71bc764c71456d10483f754884223959a5@35.240.206.208:26656,ddd9aade8e12d72cc874263c8b854e579903d21c@178.18.240.65:26656,eb62523dfa0f9bd66a9b0c281382702c185ce1ee@38.242.145.138:26656,0305205b9c2c76557381ed71ac23244558a51099@162.55.65.162:26656,086d19f4d7542666c8b0cac703f78d4a8d4ec528@135.148.232.105:26656,3e5f3247d41d2c3ceeef0987f836e9b29068a3e9@168.119.31.198:56256,8b72b2f2e027f8a736e36b2350f6897a5e9bfeaa@131.153.232.69:26656,6a2f6a5cd2050f72704d6a9c8917a5bf0ed63b53@93.115.25.41:26656,e09fa8cc6b06b99d07560b6c33443023e6a3b9c6@65.21.131.187:26656"
# config pruning
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.junctiond/config/app.toml 
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.junctiond/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"19\"/" $HOME/.junctiond/config/app.toml
# set minimum gas price, enable prometheus and disable indexing
sed -i 's|minimum-gas-prices =.*|minimum-gas-prices = "0.001uamf"|g' $HOME/.junctiond/config/app.toml
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.junctiond/config/config.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.junctiond/config/config.toml
```
## Custom Port
```
sed -i.bak -e "s%:1317%:13317%g;
s%:8080%:13080%g;
s%:9090%:13090%g;
s%:9091%:13091%g;
s%:8545%:13545%g;
s%:8546%:13546%g;
s%:6065%:13065%g" $HOME/.junctiond/config/app.toml

sed -i.bak -e "s%:26658%:13658%g;
s%:26657%:13657%g;
s%:6060%:13060%g;
s%:26656%:13656%g;
s%^external_address = \"\"%external_address = \"$(wget -qO- eth0.me):13656\"%;
s%:26660%:13660%g" $HOME/.junctiond/config/config.toml
```
## Start Node
```
sudo systemctl restart junction && journalctl -fu junction -o cat
```
