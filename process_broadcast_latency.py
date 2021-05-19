#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Date    : 2021-05-13 13:52:00

import os
import sys
import glob
import json

import numpy as np
import matplotlib.pyplot as plt


def plot_throughput(no_protection_latency, protection_latency):
    n = len(no_protection_latency)
    x = np.arange(1, n + 1)
    avg1 = np.mean(no_protection_latency)
    avg2 = np.mean(protection_latency)

    plt.figure(figsize=(13, 7))
    plt.rcParams.update({'font.size': 24})
    plt.plot(x, no_protection_latency, 'o', label='baseline', color='b')
    plt.axhline(
        y=avg1, linestyle='--', label='baseline avg. = %f' % avg1, color='b')
    plt.plot(x, protection_latency, 'x', label='protected', color='r')
    plt.axhline(
        y=avg2, linestyle='--', label='protected avg. = %f' % avg2, color='r')

    plt.ylabel('Latency (ms)')
    plt.ylim(0, (avg1 + avg2) + 0.05)

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
    send_data = []
    with open(send_data_path, 'r') as fp:
        for line in fp:
            send_data.append(float(line.strip().split(': ')[0]))
    send_data = np.array(send_data) * 1000

    # Load recv.txt
    recv_data = []
    with open(recv_data_path, 'r') as fp:
        for line in fp:
            recv_data.append(float(line.strip().split(': ')[0]))
    recv_data = np.array(recv_data) * 1000

    latency = recv_data - send_data

    print(data_dir)
    print("Latency (ms): %f (avg), %f (std dev)" % (
        np.mean(latency), np.std(latency)))

    return latency


def main(no_protection_data_dir, protection_data_dir):
    no_protection_latency = process_data(no_protection_data_dir)
    protection_latency = process_data(protection_data_dir)

    if len(no_protection_latency) != len(protection_latency):
        return

    plot_throughput(no_protection_latency, protection_latency)


if __name__ == '__main__':
    if len(sys.argv) < 3:
        print('Insufficient arguments!')
        sys.exit(1)
    no_protection_data_dir = sys.argv[1]
    protection_data_dir = sys.argv[2]
    main(no_protection_data_dir, protection_data_dir)
