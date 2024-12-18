|      Chain ID       |  Port  |  Version  |
|---------------------|--------|-----------|
|ignite_186-1 |  123   |   v1.0.20-ignite   |

# Manual node setup
Here you have to put name of your moniker (validator) that will be visible in explorer
```
MONIKER="Your Moniker"
```
## Update and install packages for compiling
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl git wget htop tmux build-essential jq make lz4 gcc unzip -y
sudo apt-get install -y libssl-dev
```
### Install go
```
ver="1.23.0" 
cd $HOME 
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" 
sudo rm -rf /usr/local/go 
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" 
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile    
```
## Build binary
```
cd $HOME
wget -O pellcored https://github.com/0xPellNetwork/network-config/releases/download/v1.0.20-ignite/pellcored-v1.0.20-linux-amd64
chmod +x $HOME/pellcored
mv $HOME/pellcored $HOME/go/bin/pellcored

WASMVM_VERSION=v2.1.2
export LD_LIBRARY_PATH=~/.pellcored/lib
mkdir -p $LD_LIBRARY_PATH
wget "https://github.com/CosmWasm/wasmvm/releases/download/$WASMVM_VERSION/libwasmvm.$(uname -m).so" -O "$LD_LIBRARY_PATH/libwasmvm.$(uname -m).so"
echo "export LD_LIBRARY_PATH=$HOME/.pellcored/lib:$LD_LIBRARY_PATH" >> $HOME/.bash_profile
source ~/.bash_profile
```
## Config and init app
```
pellcored config node tcp://localhost:12357
pellcored config keyring-backend os
pellcored config chain-id ignite_186-1
pellcored init $MONIKER --chain-id ignite_186-1
```
## Download Genesis & Addrbook
```
wget -O $HOME/.pellcored/config/genesis.json https://server-5.itrocket.net/testnet/pell/genesis.json
wget -O $HOME/.pellcored/config/addrbook.json  https://server-5.itrocket.net/testnet/pell/addrbook.json
```
## Configure
```
SEEDS="5f10959cc96b5b7f9e08b9720d9a8530c3d08d19@pell-testnet-seed.itrocket.net:58656"
PEERS="d003cb808ae91bad032bb94d19c922fe094d8556@pell-testnet-peer.itrocket.net:58656,28c0fcd184c31ac7f3e2b3a91ae60dedc086b0c3@94.130.204.227:26656,739d38ce19e4d2b22eb77016f91bf468e93c22af@37.252.186.230:26656,4efd5164f02c3af4247fc0292922af8d08a46ae6@51.89.1.16:26656,d52c32a6a8510bdf0d33909008041b96d95c8408@34.87.39.12:26656,f1049cc2be2902053bcf5ea1a553414d8a978ef6@[2a01:4f8:110:4265::11]:26656,d020ae784e920290fb8fe5cc58ca9139f2fcec57@161.35.27.208:26656,48c48532950e51fba80a1031d5a58c627737ed84@65.109.82.111:25656,a07fb3b45241b774db25f0704a65419f0e98be14@62.171.130.196:26656,80a0c0db6ce1f3f14cae20a09f1d874d987635ba@149.50.96.58:26656,407c7229a207a0c932a56ab3a979fc2312751390@162.19.240.7:28656"
sed -i -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*seeds *=.*/seeds = \"$SEEDS\"/}" \
       -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*persistent_peers *=.*/persistent_peers = \"$PEERS\"/}" $HOME/.pellcored/config/config.toml
```
```
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.pellcored/config/app.toml 
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.pellcored/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"19\"/" $HOME/.pellcored/config/app.toml
```
```
sed -i 's|minimum-gas-prices =.*|minimum-gas-prices = "0apell"|g' $HOME/.pellcored/config/app.toml
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.pellcored/config/config.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.pellcored/config/config.toml
```
## Custom Port
```
sed -i -e "s%^proxy_app = \"tcp://0.0.0.0:26658\"%proxy_app = \"tcp://0.0.0.0:12358\"%; s%^laddr = \"tcp://0.0.0.0:26657\"%laddr = \"tcp://127.0.0.1:12357\"%; s%^pprof_laddr = \"0.0.0.0:6060\"%pprof_laddr = \"0.0.0.0:12360\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:12356\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":12366\"%" $HOME/.pellcored/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:12317\"%; s%^address = \":8080\"%address = \":12380\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:12390\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:12391\"%; s%:8545%:12345%; s%:8546%:12346%; s%:6065%:12365%" $HOME/.pellcored/config/app.toml
```
## Create service
```
sudo tee /etc/systemd/system/pellcored.service > /dev/null <<EOF
[Unit]
Description=Pell Node
After=network-online.target
[Service]
User=$USER
WorkingDirectory=$HOME/.pellcored
ExecStart=$(which pellcored) start --home $HOME/.pellcored
Environment=LD_LIBRARY_PATH=$HOME/.pellcored/lib/
Restart=on-failure
RestartSec=5
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```
## Start Node
```
sudo systemctl daemon-reload
sudo systemctl enable pellcored
sudo systemctl restart pellcored && journalctl -fu pellcored -o cat
```
