#!/bin/bash

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
