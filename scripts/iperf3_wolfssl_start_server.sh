#!/bin/bash

TOPIC=$1
LOG_TAG=$2

echo "[iperf3] Run iperf3 server at port 8080"
# replace: --logfile "/code/results/"$TOPIC"_server_"$LOG_TAG".log"
/home/seceth/iperf-wolfssl/src/iperf3 -f m -p 8080 -D -s -i 60 \
    --logfile /dev/null \
    --ssl-tls-version 1.3 \
    --ssl-server-key /code/ipsec-strongswan-confs/alice/aliceEcc256Key.pem \
    --ssl-server-cert /code/ipsec-strongswan-confs/alice/aliceEcc256Cert.pem
# Wait for iperf3 server to start
echo "[iperf3] Wait for the completion ..."
until pids=$(pidof iperf3)
do
    sleep 1
done
echo "[iperf3] Done!"
