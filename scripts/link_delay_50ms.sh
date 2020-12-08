#!/bin/bash

sudo tc qdisc add dev eth0 parent 1:11 handle 10: netem delay 50ms
