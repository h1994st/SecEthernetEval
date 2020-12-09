#!/bin/bash

BIT_RATE=$1

echo "[Link] Set the link bit rate to "$BIT_RATE
sudo tc qdisc add dev eth0 handle 1: root htb default 11
sudo tc class add dev eth0 parent 1: classid 1:1 htb rate $BIT_RATE
sudo tc class add dev eth0 parent 1:1 classid 1:11 htb rate $BIT_RATE
echo "[Link] Done!"
