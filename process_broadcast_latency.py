#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Date    : 2021-05-13 13:52:00

import os
import sys
import glob
import json

import numpy as np
import matplotlib.pyplot as plt


def main(data_dir):
    # Load send.txt
    send_data_path = os.path.join(data_dir, 'send.txt')
    send_data = []
    with open(send_data_path, 'r') as fp:
        for line in fp:
            send_data.append(float(line.strip().split(': ')[0]))
    send_data = np.array(send_data)

    # Load recv.txt
    recv_data_path = os.path.join(data_dir, 'recv.txt')
    recv_data = []
    with open(recv_data_path, 'r') as fp:
        for line in fp:
            recv_data.append(float(line.strip().split(': ')[0]))
    recv_data = np.array(recv_data)

    latency = recv_data - send_data

    print(data_dir)
    print("Latency (ms): %f (avg), %f (std dev)" % (
        np.mean(latency) * 1000, np.std(latency) * 1000))


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Insufficient arguments!')
        sys.exit(1)
    data_dir = sys.argv[1]
    main(data_dir)
