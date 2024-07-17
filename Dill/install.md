# Validator Setup Guide

## Network Details

| Network Name | Dill Testnet Andes |
| --- | --- |
| RPC URL | https://rpc-andes.dill.xyz/ |
| Chain ID | 558329 |
| Currency symbol | DILL |
| Explorer URL | https://andes.dill.xyz/ |

## Hardware Requirements

| Component | Minimum Requirement |
| --- | --- |
| CPU | 2 cores |
| Memory | 2G |
| Disk | 20G |
| Network | 1MB/s |
| OS | Ubuntu 22.04 - macOS |

## Setup Steps

### 1. Download and Extract the Light Validator Binary Package
- General Linux-like: [Download Link](https://dill-release.s3.ap-southeast-1.amazonaws.com/linux/dill.tar.gz)
- macOS: [Download Link](https://dill-release.s3.ap-southeast-1.amazonaws.com/macos/dill.tar.gz)
```bash
curl -O https://dill-release.s3.ap-southeast-1.amazonaws.com/linux/dill.tar.gz && tar -xzvf dill.tar.gz && cd dill
```
### 2. Generate Validator Keys
```bash
./dill_validators_gen new-mnemonic --num_validators=1 --chain=andes --folder=./
```
_This will generate validator keys in the `./validator_keys` directory._
### 3. Import Validator Keys
```bash
./dill-node accounts import --andes --wallet-dir ./keystore --keys-dir validator_keys/ --accept-terms-of-use
```
_During this process, configure and save your keystore password._

### 4. Save Password to a File
_Replace your-Password_
```bash
echo <your-password> > walletPw.txt
```
### 5. Start Light Validator Node
```bash
./start_light.sh -p walletPw.txt
```
### 6. Verify Node is Running
_Run the following command to check if the node is up and running:_
```bash
ps -ef | grep dill
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
