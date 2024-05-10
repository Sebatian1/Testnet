# Managing keys
### Generate new key
```
0gchaind keys add wallet
```
```
0gchaind keys add wallet --eth
```
### Recover key
  ```
0gchaind keys add wallet --recover
```
 ```
0gchaind keys add wallet --recover --eth
```
### Delete key
```
0gchaind keys delete wallet
```
### List all key
```
0gchaind keys list
```
### Export eth key
```
0gchaind keys unsafe-export-eth-key wallet
```
### Query wallet balances
```
0gchaind q bank balances $(0gchaind keys show wallet -a)
```
# Managing validators
### Create validator
```
0gchaind tx staking create-validator \
  --amount=<staking_amount>ua0gi \
  --pubkey=$(0gchaind tendermint show-validator) \
  --moniker="<your_validator_name>" \
  --chain-id=zgtendermint_16600-1 \
  --commission-rate="0.10" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" \
  --min-self-delegation="1" \
  --from=<key_name> \
  --gas-adjustment=1.4 \
```
### Edit validator
```
0gchaind tx staking edit-validator \
--new-moniker "NewMonkiker" \
--identity "xxx" \
--website "xxx" \
--details "xxx" \
--security-contact "" \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
-chain-id zgtendermint_16600-1 \
--gas=auto \
-y
```
### Unjail
```
0gchaind tx slashing unjail --from wallet -y
```
### View validator details
```
0gchaind keys show wallet --bech val -a
```
### Query active validators
```
0gchaind q staking validators -o json --limit=1000 \
| jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' \
| jq -r '.tokens + " - " + .description.moniker' \
| sort -gr | nl
```
### Query inactive validators
```
0gchaind q staking validators -o json --limit=1000 \
| jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' \
| jq -r '.tokens + " - " + .description.moniker' \
| sort -gr | nl
```
# Managing Tokens
### Delegate tokens to your validator
```
0gchaind tx staking delegate $(0gchaind keys show wallet --bech val -a)  1000000ua0gi --from wallet --gas=auto -y
```
### Send token
```
0gchaind tx bank send <WALLET> <TO_WALLET> <AMOUNT>ua0gi -y
```
### Withdraw reward from all validator
```
0gchaind tx distribution withdraw-all-rewards --from wallet --chain-id zgtendermint_16600-1 --gas-adjustment 1.4 --gas auto -y
```
### Withdraw reward and commission
```
0gchaind tx distribution withdraw-rewards $(0gchaind keys show wallet --bech val -a) --commission --from wallet --chain-id zgtendermint_16600-1 --gas-adjustment 1.4 --gas auto -y
```
### Redelegate to another validator
```
0gchaind tx staking redelegate $(0gchaind keys show wallet --bech val -a) <to-valoper-address> 1000000stake --from wallet --chain-id zgtendermint_16600-1 --gas-adjustment 1.4 --gas auto -y
```
# Governance
### Query list proposal
```
0gchaind query gov proposals
```
# View proposal by ID
```
0gchaind query gov proposal 1
```
### Vote yes
```
0gchaind tx gov vote 1 yes --from wallet -y
```
### Vote No
```
0gchaind tx gov vote 1 no --from wallet -y
```
### Vote option asbtain
```
0gchaind tx gov vote 1 abstain --from wallet -y
```
### Vote option NoWithVeto
```
0gchaind tx gov vote 1 NoWithVeto --from wallet -y
```
# Maintenance
### Check sync
```
0gchaind status 2>&1 | jq .SyncInfo
```
### Node status
```
0gchaind status | jq
```
### Get validator information
```
0gchaind status 2>&1 | jq .ValidatorInfo
```
### Get your p2p peer address
```
echo $(0gchaind tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.0gchaind/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
### Get peers live
```
curl -sS http://localhost:12057/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```
### Remove Node
```
cd $HOME
sudo systemctl stop og
sudo systemctl disable og
sudo rm /etc/systemd/system/g.service
sudo systemctl daemon-reload
sudo rm $HOME/go/bin/0gchaind
sudo rm -f $(which 0gchaind)
sudo rm -rf $HOME/0g-chain
sudo rm -rf $HOME/.0gchain
```
