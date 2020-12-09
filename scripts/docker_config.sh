#!/bin/bash

echo "[Configuration] $MY_NAME"

sudo cp /code/ipsec-strongswan-confs/alice/aliceRsaKey.pem /etc/ipsec.d/private
sudo cp /code/ipsec-strongswan-confs/alice/aliceRsaCert.pem /etc/ipsec.d/certs
sudo cp /code/ipsec-strongswan-confs/bob/bobRsaKey.pem /etc/ipsec.d/private
sudo cp /code/ipsec-strongswan-confs/bob/bobRsaCert.pem /etc/ipsec.d/certs
sudo cp /code/ipsec-strongswan-confs/caCert.pem /etc/ipsec.d/cacerts

sudo cp /code/ipsec-strongswan-confs/alice/aliceEcc256Key.pem /etc/ipsec.d/private
sudo cp /code/ipsec-strongswan-confs/alice/aliceEcc256Cert.pem /etc/ipsec.d/certs
sudo cp /code/ipsec-strongswan-confs/bob/bobEcc256Key.pem /etc/ipsec.d/private
sudo cp /code/ipsec-strongswan-confs/bob/bobEcc256Cert.pem /etc/ipsec.d/certs
sudo cp /code/ipsec-strongswan-confs/caEcc256Cert.pem /etc/ipsec.d/cacerts

echo "[Configuration] Copy IPsec configuration files"
sudo cp /code/ipsec-strongswan-confs/"$MY_NAME"/ipsec.conf /etc
sudo cp /code/ipsec-strongswan-confs/"$MY_NAME"/ipsec.secrets /etc
sudo cp /code/ipsec-strongswan-confs/"$MY_NAME"/strongswan.conf /etc

echo "[Configuration] Set up MACsec"
ALICE_MAC=02:42:ac:11:00:02
ALICE_KEY_128=`cat /code/macsec-confs/alice/aliceKey128.txt`
BOB_MAC=02:42:ac:11:00:03
BOB_KEY_128=`cat /code/macsec-confs/bob/bobKey128.txt`
sudo ip link add link eth0 macsec0 type macsec encrypt on
case $MY_NAME in
    "alice")
        sudo ip macsec add macsec0 rx port 1 address $BOB_MAC

        echo "[Configuration] Configure the TX key"
        echo "[Configuration] - KEY: alice's key, key id is \"00\""
        sudo ip macsec add macsec0 tx sa 0 pn 1 on key 00 $ALICE_KEY_128
        echo "[Configuration] Configure the RX key"
        echo "[Configuration] - SCI, including Bob's MAC address"
        echo "[Configuration] - sa & OPTS"
        echo "[Configuration] - KEY: bob's key, key id is \"01\""
        sudo ip macsec add macsec0 rx port 1 address $BOB_MAC \
                                   sa 0 pn 1 on \
                                   key 01 $BOB_KEY_128
        ;;

    "bob")
        sudo ip macsec add macsec0 rx port 1 address $ALICE_MAC

        echo "[Configuration] Configure the TX key"
        echo "[Configuration] - KEY: bob's key, key id is \"01\""
        sudo ip macsec add macsec0 tx sa 0 pn 1 on key 01 $BOB_KEY_128
        echo "[Configuration] Configure the RX key"
        echo "[Configuration] - SCI, including Alice's MAC address"
        echo "[Configuration] - sa & OPTS"
        echo "[Configuration] - KEY: alice's key, key id is \"00\""
        sudo ip macsec add macsec0 rx port 1 address $ALICE_MAC \
                                   sa 0 pn 1 on \
                                   key 00 $ALICE_KEY_128
        ;;

    *)
        echo "[Configuration] No such name:" $MY_NAME
        exit 1
        ;;

esac

echo "[Configuration] Done!"
