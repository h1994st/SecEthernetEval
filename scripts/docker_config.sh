#!/bin/bash

echo "[Configuration] $MY_NAME"

bash /code/scripts/docker_config_certs.sh
bash /code/scripts/docker_config_ipsec.sh
bash /code/scripts/docker_config_macsec.sh

echo "[Configuration] Done!"
