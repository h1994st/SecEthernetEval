#!/bin/bash

echo "[Link] Reset the link"
sudo tc qdisc del dev eth0 root
echo "[Link] Done!"
