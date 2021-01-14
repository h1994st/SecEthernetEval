#!/bin/bash

SCRIPTS_DIR=$(dirname $(realpath $0))
TOPIC="dtls_eval_handshake"
N_TIMES=$1
NET_INTERFACE=$2
OUTPUT_DIR=$3

SERVER_IP_ADDR=172.50.1.2
DTLS_VERSION=3
DTLS_CIPHER=ECDHE-ECDSA-AES128-GCM-SHA256

sudo echo "Start"

# Run server
docker-compose exec -T alice /code/scripts/wolfssl_dtls_start_server.sh \
    $DTLS_VERSION $DTLS_CIPHER $N_TIMES

# N times
for n in `seq $N_TIMES` ;
do

    nohup sudo tcpdump -i $NET_INTERFACE port 8080 \
        --time-stamp-precision nano \
        -w $OUTPUT_DIR"/"$TOPIC"_v"$DTLS_VERSION"_"$n".pcap" 2>&1 > /dev/null &
    docker-compose exec -T bob /code/scripts/wolfssl_dtls_start_client.sh \
        $SERVER_IP_ADDR $DTLS_VERSION $DTLS_CIPHER
    sleep 5  # sleep 5 seconds
    sudo pkill tcpdump

done
