#!/bin/bash

# Two ECUs
rm -f docker-compose.yml
ln -s ./confs/no_restriction_containers.yml docker-compose.yml

bash scripts/ipsec_eval.sh
mkdir results/ecu_containers/ipsec_4
mv results/ipsec_eval_client_*.log results/ecu_containers/ipsec_4

bash scripts/macsec_eval.sh
mkdir results/ecu_containers/macsec_3
mv results/macsec_eval_client_*.log results/ecu_containers/macsec_3

bash scripts/none_eval.sh
mkdir results/ecu_containers/none_3
mv results/none_eval_client_*.log results/ecu_containers/none_3

# No restriction
rm -f docker-compose.yml
ln -s ./confs/no_restriction_containers.yml docker-compose.yml

bash scripts/ipsec_eval.sh
mkdir results/no_restriction_containers/ipsec_2
mv results/ipsec_eval_client_*.log results/no_restriction_containers/ipsec_2

bash scripts/macsec_eval.sh
mkdir results/no_restriction_containers/macsec_2
mv results/macsec_eval_client_*.log results/no_restriction_containers/macsec_2

bash scripts/none_eval.sh
mkdir results/no_restriction_containers/none_2
mv results/none_eval_client_*.log results/no_restriction_containers/none_2
