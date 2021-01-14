#!/bin/bash

SCRIPTS_DIR=$(dirname $(realpath $0))
TOPIC="macsec_eval"
N_TIMES=$1

$SCRIPTS_DIR/host_init.sh

# Start MACsec
ALICE_IP_ADDR=10.1.0.2
BOB_IP_ADDR=10.1.0.3
docker-compose exec -T alice /code/scripts/macsec_start.sh $ALICE_IP_ADDR
docker-compose exec -T bob /code/scripts/macsec_start.sh $BOB_IP_ADDR

# Run iperf3
docker-compose exec -T alice /code/scripts/iperf3_start_server.sh \
    $TOPIC "macsec_all"
TEST_DURATION=120  # 2 mins

# N times
for n in `seq $N_TIMES` ;
do

    docker-compose exec -T bob /code/scripts/iperf3_start_client.sh \
        $ALICE_IP_ADDR $TEST_DURATION $TOPIC "unlimited_"$(date +%s)

done

# Stop MACsec
docker-compose exec -T alice /code/scripts/macsec_stop.sh
docker-compose exec -T bob /code/scripts/macsec_stop.sh

$SCRIPTS_DIR/host_stop.sh
