#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Date    : 2021-05-13 13:52:00

import os
import sys
import glob
import json

import numpy as np
import matplotlib.pyplot as plt


def plot_latency(protection_latency):
    n = len(protection_latency)
    x = np.arange(1, n + 1)
    avgval = np.mean(protection_latency)

    plt.figure(figsize=(13, 7))
    plt.rcParams.update({'font.size': 24})
    plt.plot(x, protection_latency, 'x', label='w/ protection', color='r')
    plt.axhline(
        y=avgval, linestyle='--',
        label='w/ protection avg. = %f' % avgval, color='r')

    plt.ylabel('Latency (ms)')
    # plt.ylim(0, (avgval) + 0.05)

    plt.legend()
    plt.grid(True, axis='y', linestyle='--')
    plt.tight_layout()
    # plt.margins(x=0, y=0)
    plt.show()
    # plt.savefig('throughput_figure.png')


def plot_cdf(protection_latency):
    # H, X1 = np.histogram(protection_latency, bins=10, normed=True)
    # dx = X1[1] - X1[0]
    # F1 = np.cumsum(H)*dx

    N = len(protection_latency)
    X2 = np.sort(protection_latency)
    F2 = np.array(range(N))/float(N)

    plt.rcParams.update({'font.size': 12})

    # plt.plot(X1[1:], F1)
    plt.plot(X2, F2)

    plt.xlabel('Latency (ms)')
    plt.grid(True, axis='x', linestyle='--')
    plt.tight_layout()

    plt.show()


def process_data(data_dir, recv_i):
    send_data_path = os.path.join(data_dir, 'send.txt')
    if not os.path.exists(send_data_path):
        return []

    recv_filename = 'recv.txt'
    if recv_i > 0:
        recv_filename = 'recv%d.txt' % recv_i
    recv_data_path = os.path.join(data_dir, recv_filename)
    if not os.path.exists(recv_data_path):
        return []

    # Load send.txt
    send_data = {}
    with open(send_data_path, 'r') as fp:
        for line in fp:
            items = line.strip().split(': ')
            if len(items) == 1:
                # no data
                continue
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

        diff = recv_data[i] - send_data[i]
        latency.append(diff)

    # s --> ms
    latency = np.array(latency) * 1000

    print(data_dir)
    print("Latency (ms): %f (avg), %f (std dev)" % (
        np.mean(latency), np.std(latency)))
    print("  - min: %f, max: %f" % (np.min(latency), np.max(latency)))
    num = len(latency) + num_loss
    print("#Loss: %d (%f)" % (num_loss, float(num_loss) / num))

    num1 = len(latency[latency < np.mean(latency)])
    total1 = len(latency)
    print('# < avg.: %d' % num1)
    print('#elements: %d' % total1)
    print('percentage: %f' % (float(num1) / float(total1)))
    print('mean: %f' % np.mean(latency[latency < np.mean(latency)]))

    return latency


def main(protection_data_dir, recv_i):
    protection_latency = process_data(protection_data_dir, recv_i)

    plot_cdf(protection_latency)
    # plot_latency(protection_latency)


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Insufficient arguments!')
        sys.exit(1)
    protection_data_dir = sys.argv[1]
    recv_i = 0
    if len(sys.argv) == 3:
        recv_i = int(sys.argv[2])
    main(protection_data_dir, recv_i)
