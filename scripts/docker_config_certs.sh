#!/bin/bash

echo "[Configuration] Copy certificates"
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
