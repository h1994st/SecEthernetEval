#!/bin/bash

echo "[iperf3] Run iperf3 server at port 8080"
iperf3 -p 8080 -D -1 -s --logfile /code/results/ipsec_eval_server.log
# Wait for iperf3 server to start
echo "[iperf3] Wait for the completion ..."
until pids=$(pidof iperf3)
do
    sleep 1
done
echo "[iperf3] Done!"
