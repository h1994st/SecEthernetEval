#!/bin/bash

echo "[MACsec] Start hostapd"
sudo hostapd -B /code/macsec-confs/alice/hostapd.conf

# Wait for hostapd to start
echo "[MACsec] Wait for the completion ..."
until pids=$(pidof hostapd)
do
    sleep 1
done

echo "[MACsec] Done!"
