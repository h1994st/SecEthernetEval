#!/bin/bash

SERVER_IP_ADDR=$1
TEST_DURATION=$2
TOPIC=$3
LOG_TAG=$4

echo "[iperf3] Run iperf3 client"
echo "[iperf3] Server IP:" $SERVER_IP_ADDR
echo "[iperf3] Test duration:" $TEST_DURATION
/home/seceth/iperf-wolfssl/src/iperf3 -f m -c $SERVER_IP_ADDR -p 8080 -i 60 -4 -t $TEST_DURATION -b 0 \
    --logfile "/code/results/"$TOPIC"_client_"$LOG_TAG".log"
echo "[iperf3] Done!"
