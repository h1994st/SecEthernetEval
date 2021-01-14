#!/bin/bash

echo "[MACsec] Start wpa_supplicant"
sudo wpa_supplicant -B -i eth0 -D macsec_linux \
    -c /code/macsec-confs/bob/wpa_supplicant.conf

# Wait for wpa_supplicant to start
echo "[MACsec] Wait for the completion ..."
until pids=$(pidof wpa_supplicant)
do
    sleep 1
done

echo "[MACsec] Wait for handshake ..."
until macsec_devs=$(ip macsec show)
do
    sleep 1
done
sleep 3

echo "[MACsec] Done!"
