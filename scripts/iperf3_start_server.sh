#!/bin/bash

LOG_TAG=$1

echo "[iperf3] Run iperf3 server at port 8080"
iperf3 -J -p 8080 -D -s --logfile "/code/results/ipsec_eval_server_"$LOG_TAG".log"
# Wait for iperf3 server to start
echo "[iperf3] Wait for the completion ..."
until pids=$(pidof iperf3)
do
    sleep 1
done
echo "[iperf3] Done!"
