#!/bin/bash

DATA_SIZE=$1
LOG_TAG=$2

echo "[iperf3] Run iperf3 client"
echo "[iperf3] Data size:" $DATA_SIZE
iperf3 -J -c 172.50.1.2 -p 8080 -i 1 -4 -n $DATA_SIZE -b 0 \
    --logfile "/code/results/ipsec_eval_client_"$LOG_TAG".log"
echo "[iperf3] Done!"
