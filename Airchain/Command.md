## Managing keys
Generate new key
```
junctiond keys add wallet
```
Recover key
```
junctiond keys add wallet --recover
```
List all key
```
junctiond keys list
```
Query wallet balances
```
junctiond q bank balances $(junctiond keys show wallet -a)
```

## Managing validators
Create validator
```
junctiond tx staking create-validator \
--amount=10000000amf \
--pubkey=$(junctiond tendermint show-validator) \
--moniker=$MONIKER \
--identity="YOUR_KEYBASE_ID" \
--details="YOUR_DETAILS" \
--website="YOUR_WEBSITE_URL" \
--chain-id=junction \
--commission-rate=0.10 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1000 \
--from=wallet \
--gas-adjustment=1.5 \
--fees=200amf \ 
-y
```
Edit validator
```
junctiond tx staking edit-validator \
--new-moniker="YOUR MONIKER" \
--identity="IDENTITY KEYBASE" \
--details="DETAILS VALIDATOR" \
--website="LINK WEBSITE" \
--chain-id=junction \
--from=wallet \
--gas-adjustment=1.5 \
--fees=200amf \
-y
```
Unjail
```
junctiond tx slashing unjail --from wallet --chain-id junction --gas-adjustment 1.5 --fees 200amf -y
```
View validator details
```
junctiond keys show wallet --bech val -a
```
Query active validators
```
junctiond q staking validators -o json --limit=1000 \
| jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' \
| jq -r '.tokens + " - " + .description.moniker' \
| sort -gr | nl
```
Query inactive validators
```
junctiond q staking validators -o json --limit=1000 \
| jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' \
| jq -r '.tokens + " - " + .description.moniker' \
| sort -gr | nl
```

## Managing Tokens
Delegate tokens to your validator
```
junctiond tx staking delegate $(junctiond keys show wallet --bech val -a)  1000000amf --from wallet --chain-id junction --gas=auto -y
```
Send token
```
junctiond tx bank send <WALLET> <TO_WALLET> <AMOUNT>amf --gas=500000 -y
```
Withdraw reward from all validator
```
junctiond tx distribution withdraw-all-rewards --from wallet --chain-id junction --gas-adjustment 1.5 --fees 200amf -y
```
Withdraw reward and commission
```
junctiond tx distribution withdraw-rewards $(junctiond keys show wallet --bech val -a) --commission --from wallet --chain-id junction --gas-adjustment 1.5 --fees 200amf -y
```
Redelegate to another validator
```
junctiond tx staking redelegate $(junctiond keys show wallet --bech val -a) <to-valoper-address> 1000000stake --from wallet --chain-id junction --gas-adjustment 1.5 --fees 200amf -y
```

## Governance
Query list proposal
```
junctiond query gov proposals
```
View proposal by ID
```
junctiond query gov proposal 1
```
Vote yes
```
junctiond tx gov vote 1 yes --from wallet -y
```
Vote No
```
junctiond tx gov vote 1 no --from wallet -y
```
Vote option asbtain
```
junctiond tx gov vote 1 abstain --from wallet -y
```
Vote option NoWithVeto
```
junctiond tx gov vote 1 NoWithVeto --from wallet -y
```

## Maintenance
Check sync
```
junctiond status 2>&1 | jq .SyncInfo
```
Node status
```
junctiond status | jq
```
Get validator information
```
junctiond status 2>&1 | jq .ValidatorInfo
```
Get your p2p peer address
```
echo $(junctiond tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.0gchain/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
Get peers live
```
curl -sS http://localhost:${og}57/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```
## Remove node
sudo systemctl stop junction
sudo systemctl disable junction
rm /etc/systemd/system/junction.service
sudo systemctl daemon-reload
cd $HOME
rm -rf .junction
rm -rf $(which junctiond)
