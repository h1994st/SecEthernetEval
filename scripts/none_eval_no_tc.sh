#!/bin/bash

SCRIPTS_DIR=$(dirname $(realpath $0))
TOPIC="none_eval"
N_TIMES=$1

rm -f docker-compose.yml
ln -s ./confs/no_restriction_containers.yml docker-compose.yml

# Start two Docker containers for Alice and Bob
docker-compose up -d

# Run iperf3
docker-compose exec -T alice /code/scripts/iperf3_start_server.sh \
    $TOPIC "none_all"
DATA_SIZE=104857600  # 100 MB of data
SERVER_IP_ADDR=172.50.1.2

# N times
for n in `seq $N_TIMES` ;
do
    # 5GB of data
    docker-compose exec -T bob /code/scripts/iperf3_start_client.sh \
        $SERVER_IP_ADDR 5368709120 $TOPIC "unlimited_"$(date +%s)

done

# Stop Docker
docker-compose down
