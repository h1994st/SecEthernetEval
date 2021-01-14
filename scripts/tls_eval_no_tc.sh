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

# N times
for n in `seq $N_TIMES` ;
do

    docker-compose exec -T bob /code/scripts/iperf3_wolfssl_start_client.sh \
        $SERVER_IP_ADDR $TEST_DURATION $TOPIC "unlimited_"$(date +%s)

done

$SCRIPTS_DIR/host_stop.sh
