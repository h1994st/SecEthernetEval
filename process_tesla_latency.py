#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Date    : 2021-05-13 13:52:00

import os
import sys
import glob
import json

import numpy as np
import matplotlib.pyplot as plt


def plot_throughput(protection_latency):
    n = len(protection_latency)
    x = np.arange(1, n + 1)
    avgval = np.mean(protection_latency)

    plt.figure(figsize=(13, 7))
    plt.rcParams.update({'font.size': 24})
    plt.plot(x, protection_latency, 'x', label='protected', color='r')
    plt.axhline(
        y=avgval, linestyle='--', label='protected avg. = %f' % avgval, color='r')

    plt.ylabel('Latency (s)')
    # plt.ylim(0, (avgval) + 0.05)

    plt.legend()
    plt.grid(True, axis='y', linestyle='--')
    plt.tight_layout()
    # plt.margins(x=0, y=0)
    plt.show()
    # plt.savefig('throughput_figure.png')


def process_data(data_dir):
    send_data_path = os.path.join(data_dir, 'send.txt')
    if not os.path.exists(send_data_path):
        return []

    recv_data_path = os.path.join(data_dir, 'recv.txt')
    if not os.path.exists(recv_data_path):
        return []

    # Load send.txt
    send_data = {}
    with open(send_data_path, 'r') as fp:
        for line in fp:
            items = line.strip().split(': ')
            send_data[int(items[1])] = float(items[0])

    # Load recv.txt
    recv_data = {}
    with open(recv_data_path, 'r') as fp:
        for line in fp:
            items = line.strip().split(': ')
            if len(items) == 1:
                # no data: violated security condition
                continue
            recv_data[int(items[1])] = float(items[0])

    print("send_data: len=%d" % len(send_data))
    print("recv_data: len=%d" % len(recv_data))

    max_recv_index = max(recv_data.keys())
    print("max_recv_index: %d" % max_recv_index)

    latency = []
    num_loss = 0

    for i in send_data:
        if i > max_recv_index:
            continue

        if i not in recv_data:
            num_loss += 1
            continue

        latency.append(recv_data[i] - send_data[i])

    print(data_dir)
    print("Latency (s): %f (avg), %f (std dev)" % (
        np.mean(latency), np.std(latency)))
    print("  - min: %f, max: %f" % (np.min(latency), np.max(latency)))
    num = len(latency) + num_loss
    print("#Loss: %d (%f)" % (num_loss, float(num_loss) / num))

    return latency


def main(protection_data_dir):
    protection_latency = process_data(protection_data_dir)

    plot_throughput(protection_latency)


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Insufficient arguments!')
        sys.exit(1)
    protection_data_dir = sys.argv[1]
    main(protection_data_dir)
