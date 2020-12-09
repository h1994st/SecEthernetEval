#!/bin/bash

SERVER_IP_ADDR=$1
DATA_SIZE=$2
TOPIC=$3
LOG_TAG=$4

echo "[iperf3] Run iperf3 client"
echo "[iperf3] Server IP:" $SERVER_IP_ADDR
echo "[iperf3] Data size:" $DATA_SIZE
iperf3 -J -c $SERVER_IP_ADDR -p 8080 -i 60 -4 -n $DATA_SIZE -b 0 \
    --logfile "/code/results/"$TOPIC"_client_"$LOG_TAG".log"
echo "[iperf3] Done!"
