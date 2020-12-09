#!/bin/bash

TOPIC=$1
LOG_TAG=$2

echo "[iperf3] Run iperf3 server at port 8080"
iperf3 -f b -p 8080 -D -s -i 60 \
    --logfile /dev/null  # replace "/code/results/"$TOPIC"_server_"$LOG_TAG".log"
# Wait for iperf3 server to start
echo "[iperf3] Wait for the completion ..."
until pids=$(pidof iperf3)
do
    sleep 1
done
echo "[iperf3] Done!"
