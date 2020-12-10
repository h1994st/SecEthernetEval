#!/bin/bash

SCRIPTS_DIR=$(dirname $(realpath $0))
TOPIC="macsec_eval"

$SCRIPTS_DIR/host_init.sh

# Start MACsec
ALICE_IP_ADDR=10.1.0.2
BOB_IP_ADDR=10.1.0.3
docker-compose exec -T alice /code/scripts/macsec_start.sh $ALICE_IP_ADDR
docker-compose exec -T bob /code/scripts/macsec_start.sh $BOB_IP_ADDR

# Run iperf3
docker-compose exec -T alice /code/scripts/iperf3_start_server.sh \
    $TOPIC "macsec_all"
DATA_SIZE=104857600  # 100 MB of data
for bit_rate in `seq 100 100 1000` ;
do

    # Set link bit rate
    docker-compose exec -T alice /code/scripts/link_set_rate.sh $bit_rate"Mbit"
    docker-compose exec -T bob /code/scripts/link_set_rate.sh $bit_rate"Mbit"

    # 10 times
    for n in `seq 10` ;
    do

        docker-compose exec -T bob /code/scripts/iperf3_start_client.sh \
            $ALICE_IP_ADDR $DATA_SIZE $TOPIC $bit_rate"Mbit_"$(date +%s)

    done

    # Reset link
    docker-compose exec -T alice /code/scripts/link_reset.sh
    docker-compose exec -T bob /code/scripts/link_reset.sh

done

# 10 times
for n in `seq 10` ;
do

    docker-compose exec -T bob /code/scripts/iperf3_start_client.sh \
        $ALICE_IP_ADDR $DATA_SIZE $TOPIC "unlimited_"$(date +%s)

done

# Stop MACsec
docker-compose exec -T alice /code/scripts/macsec_stop.sh
docker-compose exec -T bob /code/scripts/macsec_stop.sh

$SCRIPTS_DIR/host_stop.sh