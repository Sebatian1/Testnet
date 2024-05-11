### Reset blockchain data
_Make sure backup your priv_validator_state.json before reset_
```
sudo systemctl stop og
cp $HOME/.0gchain/data/priv_validator_state.json $HOME/.0gchain/priv_validator_state.json.backup
0gchaind tendermint unsafe-reset-all --keep-addr-book --home $HOME/.0gchain
```
### Configure State Sync
```
SNAP_RPC="https://rpc-0g.sebatian.org"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH
```
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \

s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \

s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \

s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" ~/.0gchain/config/config.toml

more ~/.0gchain/config/config.toml | grep 'rpc_servers'

more ~/.0gchain/config/config.toml | grep 'trust_height'

more ~/.0gchain/config/config.toml | grep 'trust_hash'
```
### Backup state data
_Return state file to the previous location_
```
mv $HOME/.0gchain/priv_validator_state.json.backup $HOME/.0gchain/data/priv_validator_state.json
```
Restart your nodes after perform a state sync
```
sudo systemctl start og && sudo journalctl -fu og -o cat
```
