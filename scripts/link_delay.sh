#!/bin/bash

DELAY_TIME=$1

echo "[Link] Set the delay time to "$DELAY_TIME
sudo tc qdisc add dev eth0 parent 1:11 handle 10: netem delay $DELAY_TIME
echo "[Link] Done!"
