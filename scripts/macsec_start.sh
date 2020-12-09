#!/bin/bash

IP_ADDR=$1

echo "[MACsec] Start MACsec"
sudo ip link set macsec0 up
sudo ip addr add $IP_ADDR/24 dev macsec0
echo "[MACsec] Done!"
