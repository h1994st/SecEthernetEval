#!/bin/bash

# Start two Docker containers for Alice and Bob
docker-compose up -d

# Configure Alice and Bob
docker-compose exec alice /code/scripts/docker_config.sh
docker-compose exec bob /code/scripts/docker_config.sh
