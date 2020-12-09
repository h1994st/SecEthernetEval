#!/bin/bash

IP_ADDR=$1

echo "[MACsec] Stop MACsec"
sudo ip link set macsec0 down
sudo ip link delete macsec0
echo "[MACsec] Done!"
