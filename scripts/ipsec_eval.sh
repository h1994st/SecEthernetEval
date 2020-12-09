#!/bin/bash

SCRIPTS_DIR=$(dirname $(realpath $0))
TOPIC="ipsec_eval"

$SCRIPTS_DIR/host_init.sh

# Start IPsec
docker-compose exec alice /code/scripts/ipsec_start.sh
docker-compose exec bob /code/scripts/ipsec_start.sh

# Activate IPsec communication
docker-compose exec alice /code/scripts/ipsec_activate.sh

# Run iperf3
docker-compose exec alice /code/scripts/iperf3_start_server.sh \
    $TOPIC "ipsec_all"
DATA_SIZE=104857600  # 100 MB of data
SERVER_IP_ADDR=172.50.1.2
for bit_rate in `seq 100 100 1000` ;
do

    # Set link bit rate
    docker-compose exec alice /code/scripts/link_set_rate.sh $bit_rate"Mbit"
    docker-compose exec bob /code/scripts/link_set_rate.sh $bit_rate"Mbit"

    # 10 times
    for n in `seq 10` ;
    do

        docker-compose exec bob /code/scripts/iperf3_start_client.sh \
            $SERVER_IP_ADDR $DATA_SIZE $TOPIC $bit_rate"Mbit_"$(date +%s)

    done

    # Reset link
    docker-compose exec alice /code/scripts/link_reset.sh
    docker-compose exec bob /code/scripts/link_reset.sh

done

# 10 times
for n in `seq 10` ;
do

    docker-compose exec bob /code/scripts/iperf3_start_client.sh \
        $SERVER_IP_ADDR $DATA_SIZE $TOPIC "unlimited_"$(date +%s)

done

# Stop IPsec
docker-compose exec alice /code/scripts/ipsec_stop.sh
docker-compose exec bob /code/scripts/ipsec_stop.sh

$SCRIPTS_DIR/host_stop.sh
