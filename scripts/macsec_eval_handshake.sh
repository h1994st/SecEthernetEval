#!/bin/bash

SCRIPTS_DIR=$(dirname $(realpath $0))
TOPIC="macsec_eval_handshake"
N_TIMES=$1
NET_INTERFACE=$2
OUTPUT_DIR=$3

ALICE_IP_ADDR=10.1.0.2
BOB_IP_ADDR=10.1.0.3
SERVER_IP_ADDR=$ALICE_IP_ADDR

# Configure Alice
docker-compose exec -T alice sudo cp /code/macsec-confs/alice/hostapd.eap_user /etc

sudo echo "Start"

sudo ip link set $NET_INTERFACE type bridge group_fwd_mask 0x8

# N times
for n in `seq $N_TIMES` ;
do

    # Start hostapd on alice
    docker-compose exec -T alice /code/scripts/macsec_hostapd_start.sh

    nohup sudo tcpdump -i $NET_INTERFACE ether proto 0x888e \
        --time-stamp-precision nano \
        -w $OUTPUT_DIR"/"$TOPIC"_"$n".pcap" 2>&1 > /dev/null &

    # Activate MACsec handshake
    docker-compose exec -T bob /code/scripts/macsec_wpa_start.sh

    sleep 5  # sleep 5 seconds
    sudo pkill tcpdump

    # Stop hostapd and wpa_supplicant
    docker-compose exec -T alice sudo pkill hostapd
    docker-compose exec -T bob sudo pkill wpa_supplicant

    # Stop MACsec
    docker-compose exec -T alice /code/scripts/macsec_stop.sh
    docker-compose exec -T bob /code/scripts/macsec_stop.sh

done
