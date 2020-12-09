#!/bin/bash

rm -f docker-compose.yml
ln -s ./confs/no_restriction_containers.yml docker-compose.yml

TOPIC="none_eval"

./scripts/host_init.sh

# Run iperf3
docker-compose exec alice /code/scripts/iperf3_start_server.sh \
    $TOPIC "none_all"
DATA_SIZE=5368709120  # 5 GB of data
SERVER_IP_ADDR=172.50.1.2

# 10 times
for n in `seq 10` ;
do

    docker-compose exec bob /code/scripts/iperf3_start_client.sh \
        $SERVER_IP_ADDR $DATA_SIZE $TOPIC "unlimited_"$(date +%s)

done

./scripts/host_stop.sh

mv results/none_eval_client_*.log results/no_restriction_containers/none_1
