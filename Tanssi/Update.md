### Update New Version
```
systemctl stop tanssi.service
cd /var/lib/tanssi-data
wget https://github.com/moondance-labs/tanssi/releases/download/v0.6.3/tanssi-node && \
chmod +x ./tanssi-node
```
```
systemctl restart tanssi.service && journalctl -f -u tanssi.service
```
