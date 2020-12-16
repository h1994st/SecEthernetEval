#!/bin/bash

echo "[Configuration] Copy IPsec configuration files"
sudo cp /code/ipsec-strongswan-confs/"$MY_NAME"/ipsec.conf /etc
sudo cp /code/ipsec-strongswan-confs/"$MY_NAME"/ipsec.secrets /etc
sudo cp /code/ipsec-strongswan-confs/"$MY_NAME"/strongswan.conf /etc
