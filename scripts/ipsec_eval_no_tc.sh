#!/bin/bash

SCRIPTS_DIR=$(dirname $(realpath $0))
TOPIC="ipsec_eval"
N_TIMES=$1

$SCRIPTS_DIR/host_init.sh

# Start IPsec
docker-compose exec -T alice /code/scripts/ipsec_start.sh
docker-compose exec -T bob /code/scripts/ipsec_start.sh

# Activate IPsec communication
docker-compose exec -T alice /code/scripts/ipsec_activate.sh

# Run iperf3
docker-compose exec -T alice /code/scripts/iperf3_start_server.sh \
    $TOPIC "ipsec_all"
TEST_DURATION=120  # 2 mins
SERVER_IP_ADDR=172.50.1.2

# N times
for n in `seq $N_TIMES` ;
do

    docker-compose exec -T bob /code/scripts/iperf3_start_client.sh \
        $SERVER_IP_ADDR $TEST_DURATION $TOPIC "unlimited_"$(date +%s)

done

# Stop IPsec
docker-compose exec -T alice /code/scripts/ipsec_stop.sh
docker-compose exec -T bob /code/scripts/ipsec_stop.sh

$SCRIPTS_DIR/host_stop.sh
