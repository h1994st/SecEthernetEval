#!/bin/bash

SERVER_IP_ADDR=$1
TEST_DURATION=$2
TOPIC=$3
LOG_TAG=$4

echo "[iperf3] Run iperf3 client"
echo "[iperf3] Server IP:" $SERVER_IP_ADDR
echo "[iperf3] Test duration:" $TEST_DURATION
/home/seceth/iperf-wolfssl/src/iperf3 -f m -c $SERVER_IP_ADDR -p 8080 -i 60 -4 \
    -t $TEST_DURATION -b 0 \
    --logfile "/code/results/"$TOPIC"_client_"$LOG_TAG".log" \
    --ssl-tls-version 1.3 \
    --ssl-client-cert /code/ipsec-strongswan-confs/caEcc256Cert.pem \
    --ssl-suites-file /code/tls13-confs/ciphers.txt
echo "[iperf3] Done!"
