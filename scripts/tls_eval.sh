#!/bin/bash

SCRIPTS_DIR=$(dirname $(realpath $0))
TOPIC="tls_eval"
N_TIMES=$1

# Start two Docker containers for Alice and Bob
docker-compose up -d

# Run iperf3
docker-compose exec -T alice /code/scripts/iperf3_wolfssl_start_server.sh \
    $TOPIC "tls_all"
TEST_DURATION=120  # 2 mins
SERVER_IP_ADDR=172.50.1.2
for bit_rate in `seq 100 100 1000` ;
do

    # Set link bit rate
    docker-compose exec -T alice /code/scripts/link_set_rate.sh $bit_rate"Mbit"
    docker-compose exec -T bob /code/scripts/link_set_rate.sh $bit_rate"Mbit"

    # N times
    for n in `seq $N_TIMES` ;
    do

        docker-compose exec -T bob /code/scripts/iperf3_wolfssl_start_client.sh \
            $SERVER_IP_ADDR $TEST_DURATION $TOPIC $bit_rate"Mbit_"$(date +%s)

    done

    # Reset link
    docker-compose exec -T alice /code/scripts/link_reset.sh
    docker-compose exec -T bob /code/scripts/link_reset.sh

done

# N times
for n in `seq $N_TIMES` ;
do

    docker-compose exec -T bob /code/scripts/iperf3_wolfssl_start_client.sh \
        $SERVER_IP_ADDR $TEST_DURATION $TOPIC "unlimited_"$(date +%s)

done

$SCRIPTS_DIR/host_stop.sh
