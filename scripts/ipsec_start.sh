#!/bin/bash

echo "[IPsec] Start IPsec"
sudo ipsec start

# Wait for IPsec to start
echo "[IPsec] Wait for the completion ..."
until pids=$(pidof starter)
do
    sleep 1
done
until pids=$(pidof charon)
do
    sleep 1
done

echo "[IPsec] Done!"
