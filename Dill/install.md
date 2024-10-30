# Validator Setup Guide

## Network Details

| Network Name | Dill Testnet Alps |
| --- | --- |
| RPC URL | https://rpc-alps.dill.xyz |
| Chain ID | 102125 |
| Currency symbol | DILL |
| Explorer URL | https://alps.dill.xyz |

## Hardware Requirements

| Component | Minimum Requirement |
| --- | --- |
| CPU | 2 cores |
| Memory | 2G |
| Disk | 20G |
| Bandwidth | 8MB/s |
| OS | Ubuntu LTS 20.04+/MacOS |

## Download and run the auto setup script:
```
curl -sO https://raw.githubusercontent.com/DillLabs/launch-dill-node/main/dill.sh  && chmod +x dill.sh && ./dill.sh
```
### 6. Command
- health check:
```bash
cd $HOME/dill && ./health_check.sh -v
```
- Stop dill:
```bash
cd $HOME/dill && ./stop_dill_node.sh
```
- Start Dill:
```bash
cd $HOME/dill && ./start_dill_node.sh
```
- Show pubkey:
```bash
cd $HOME/dill && ./show_pubkey.sh
```
- Exit validator:
```bash
cd $HOME/dill && ./exit_validator.sh
```
## Staking

1. Visit [Dill Staking](https://staking.dill.xyz/)
2. Upload `deposit_data-*.json` file.
Use `scp` to copy the file locally or:
```bash
cat ./validator_keys/deposit_data-xxxx.json
```
Copy the content to your local machine for uploading.
This summarized guide should help you set up and run a validator on the Andes Network Dill Testnet. If you need further details or run into issues, refer to the full guide or documentation.
