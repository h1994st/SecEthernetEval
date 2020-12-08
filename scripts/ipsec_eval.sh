#!/bin/bash

# Start two Docker containers for Alice and Bob
docker-compose up -d

# Configure Alice and Bob
docker-compose exec alice /code/scripts/config.sh
docker-compose exec bob /code/scripts/config.sh

# Start IPsec
docker-compose exec alice /code/scripts/ipsec_start.sh
docker-compose exec bob /code/scripts/ipsec_start.sh

# Activate IPsec communication
docker-compose exec alice /code/scripts/ipsec_activate.sh

# Run iperf3
docker-compose exec alice /code/scripts/iperf3_start_server.sh
docker-compose exec bob /code/scripts/iperf3_start_client.sh

# Stop IPsec
docker-compose exec alice /code/scripts/ipsec_stop.sh
docker-compose exec bob /code/scripts/ipsec_stop.sh

# Stop Docker
docker-compose down
