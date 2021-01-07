#!/bin/bash

SCRIPTS_DIR=$(dirname $(realpath $0))
TOPIC="none_eval"
N_TIMES=1

rm -f docker-compose.yml
ln -s ./confs/no_restriction_containers.yml docker-compose.yml

# Start two Docker containers for Alice and Bob
docker-compose up -d

# Run iperf3
docker-compose exec -T alice /code/scripts/iperf3_start_server.sh \
    $TOPIC "none_all"
DATA_SIZE=104857600  # 100 MB of data
SERVER_IP_ADDR=172.50.1.2
for bit_rate in `seq 100 100 1000` ;
do

    # Set link bit rate
    docker-compose exec -T alice /code/scripts/link_set_rate.sh $bit_rate"Mbit"
    docker-compose exec -T bob /code/scripts/link_set_rate.sh $bit_rate"Mbit"

    # N times
    for n in `seq $N_TIMES` ;
    do

        docker-compose exec -T bob /code/scripts/iperf3_start_client.sh \
            $SERVER_IP_ADDR $DATA_SIZE $TOPIC $bit_rate"Mbit_"$(date +%s)

    done

    # Reset link
    docker-compose exec -T alice /code/scripts/link_reset.sh
    docker-compose exec -T bob /code/scripts/link_reset.sh

done

# N times
for n in `seq $N_TIMES` ;
do
    # 5GB of data
    docker-compose exec -T bob /code/scripts/iperf3_start_client.sh \
        $SERVER_IP_ADDR 5368709120 $TOPIC "unlimited_"$(date +%s)

done

# Stop Docker
docker-compose down
