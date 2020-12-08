#!/bin/bash

DATA_SIZE=104857600

echo "[iperf3] Run iperf3 client"
iperf3 -c 172.50.1.2 -p 8080 -i 1 -4 -n $DATA_SIZE -b 0 --logfile /code/results/ipsec_eval_client.log
echo "[iperf3] Done!"
