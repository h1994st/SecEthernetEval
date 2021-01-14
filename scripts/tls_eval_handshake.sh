#!/bin/bash

SCRIPTS_DIR=$(dirname $(realpath $0))
TOPIC="tls_eval_handshake"
N_TIMES=$1
NET_INTERFACE=$2
TLS_VERSION=$3
TLS_CIPHER=$4
OUTPUT_DIR=$5

SERVER_IP_ADDR=172.50.1.2
# TLS_VERSION=4
# TLS_CIPHER=TLS13-AES128-GCM-SHA256

sudo echo "Start"

# Run iperf3
docker-compose exec -T alice /code/scripts/wolfssl_start_server.sh \
    $TLS_VERSION $TLS_CIPHER $N_TIMES

# N times
for n in `seq $N_TIMES` ;
do

    nohup sudo tcpdump -i $NET_INTERFACE port 8080 \
        --time-stamp-precision nano \
        -w $OUTPUT_DIR"/"$TOPIC"_v"$TLS_VERSION"_"$n".pcap" 2>&1 > /dev/null &
    docker-compose exec -T bob /code/scripts/wolfssl_start_client.sh \
        $SERVER_IP_ADDR $TLS_VERSION $TLS_CIPHER
    sleep 5  # sleep 5 seconds
    sudo pkill tcpdump

done
