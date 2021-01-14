#!/bin/bash

SCRIPTS_DIR=$(dirname $(realpath $0))
TOPIC="ipsec_eval_handshake"
N_TIMES=$1
NET_INTERFACE=$2
OUTPUT_DIR=$3

SERVER_IP_ADDR=172.50.1.2

# Configure Alice and Bob
docker-compose exec -T alice /code/scripts/docker_config_ipsec.sh
docker-compose exec -T bob /code/scripts/docker_config_ipsec.sh

sudo echo "Start"

# N times
for n in `seq $N_TIMES` ;
do

    # Start IPsec
    docker-compose exec -T alice /code/scripts/ipsec_start.sh
    docker-compose exec -T bob /code/scripts/ipsec_start.sh

    nohup sudo tcpdump -i $NET_INTERFACE port 500 \
        --time-stamp-precision nano \
        -w $OUTPUT_DIR"/"$TOPIC"_"$n".pcap" 2>&1 > /dev/null &

    # Activate IPsec communication
    docker-compose exec -T alice /code/scripts/ipsec_activate.sh

    sleep 5  # sleep 5 seconds
    sudo pkill tcpdump

    # Stop IPsec
    docker-compose exec -T alice /code/scripts/ipsec_stop.sh
    docker-compose exec -T bob /code/scripts/ipsec_stop.sh

done
