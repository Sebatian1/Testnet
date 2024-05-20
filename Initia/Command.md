## Managing keys
Generate new key
```
initiad keys add wallet
```
Recover key
```
initiad keys add wallet --recover
```
List all key
```
initiad keys list
```
Query wallet balances
```
initiad q bank balances $(initiad keys show wallet -a)
```

## Managing validators
Create validator
```
initiad tx mstaking create-validator \
  --amount=10000000uinit \
  --pubkey=$(initiad tendermint show-validator) \
  --moniker=$MONIKER \
  --identity="YOUR_KEYBASE_ID" \
  --details="YOUR_DETAILS" \
  --website="YOUR_WEBSITE_URL" \
  --chain-id=initiation-1 \
  --commission-rate=0.10 \
  --commission-max-rate=0.20 \
  --commission-max-change-rate=0.01 \
  --min-self-delegation=1000 \
  --from=wallet \
  --gas=auto \
  --gas-adjustment=1.4 \
  --fees=300000uinit \
  -y
```
Edit validator
```
initiad tx mstaking edit-validator \
  --moniker="YOUR MONIKER" \
  --identity="IDENTITY KEYBASE" \
  --details="DETAILS VALIDATOR" \
  --website="LINK WEBSITE" \
  --chain-id=initiation-1 \
  --from=wallet \
  --gas=auto \
  --gas-adjustment=1.4 \
  --fees=300000uinit \
  -y
```
Unjail
```
initiad tx slashing unjail --from wallet --chain-id initiation-1 --gas-adjustment 1.4 --gas auto --fees=300000uinit -y
```
View validator details
```
initiad keys show wallet --bech val -a
```
Query active validators
```
initiad q mstaking validators -o json --limit=1000 \
| jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' \
| jq -r '.tokens + " - " + .description.moniker' \
| sort -gr | nl
```
Query inactive validators
```
initiad q mstaking validators -o json --limit=1000 \
| jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' \
| jq -r '.tokens + " - " + .description.moniker' \
| sort -gr | nl
```

## Managing Tokens
Delegate tokens to your validator
```
initiad tx mstaking delegate $(initiad keys show wallet --bech val -a)  1000000uinit --from wallet --chain-id initiation-1 --gas=auto -y
```
Send token
```
initiad tx bank send <WALLET> <TO_WALLET> <AMOUNT>uinit --gas=500000 -y
```
Withdraw reward from all validator
```
initiad tx distribution withdraw-all-rewards --from wallet --chain-id initiation-1 --gas-adjustment 1.4 --gas auto --fees=300000uinit -y
```
Withdraw reward and commission
```
initiad tx distribution withdraw-rewards $(initiad keys show wallet --bech val -a) --commission --from wallet --chain-id initiation-1 --gas-adjustment 1.4 --gas auto --fees=300000uinit -y
```
Redelegate to another validator
```
initiad tx mstaking redelegate $(initiad keys show wallet --bech val -a) <to-valoper-address> 1000000stake --from wallet --chain-id initiation-1 --gas-adjustment 1.4 --gas auto --fees=300000uinit -y
```

## Governance
Query list proposal
```
initiad query gov proposals
```
View proposal by ID
```
initiad query gov proposal 1
```
Vote yes
```
initiad tx gov vote 1 yes --from wallet -y
```
Vote No
```
initiad tx gov vote 1 no --from wallet -y
```
Vote option asbtain
```
initiad tx gov vote 1 abstain --from wallet -y
```
Vote option NoWithVeto
```
initiad tx gov vote 1 NoWithVeto --from wallet -y
```

## Maintenance
Check sync
```
initiad status 2>&1 | jq .SyncInfo
```
Node status
```
initiad status | jq
```
Get validator information
```
initiad status 2>&1 | jq .ValidatorInfo
```
Get your p2p peer address
```
echo $(initiad tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.initiation-1/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
Get peers live
```
curl -sS http://localhost:11957/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```
## Remove node
```
cd $HOME
sudo systemctl stop initia
sudo systemctl disable initia
sudo rm /etc/systemd/system/initia.service
sudo systemctl daemon-reload
rm -f $(which initia)
rm -rf $HOME/.initia
rm -rf $HOME/initia
```
