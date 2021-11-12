#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
import glob
import json

import numpy as np
import matplotlib.pyplot as plt


def plot_latency(no_protection_latency, protection_latency):
    n = len(no_protection_latency)
    x = np.arange(1, n + 1)
    avg1 = np.mean(no_protection_latency)
    avg2 = np.mean(protection_latency)

    plt.figure(figsize=(13, 7))
    plt.rcParams.update({'font.size': 24})
    plt.plot(x, no_protection_latency, 'o', label='w/o protection', color='b')
    plt.axhline(
        y=avg1, linestyle='--',
        label='w/o protection avg. = %f' % avg1, color='b')
    plt.plot(x, protection_latency, 'x', label='w/ protection', color='r')
    plt.axhline(
        y=avg2, linestyle='--',
        label='w/ protection avg. = %f' % avg2, color='r')

    plt.ylabel('Latency (ms)')
    plt.ylim(0, (avg1 + avg2) + 0.05)

    plt.legend()
    plt.grid(True, axis='y', linestyle='--')
    plt.tight_layout()
    # plt.margins(x=0, y=0)
    plt.show()
    # plt.savefig('throughput_figure.png')


def process_data(data_dir, num_sender, num_receiver):
    # Load send.txt
    print("[+] Load send.txt")
    send_data_path = os.path.join(data_dir, 'send.txt')
    if not os.path.exists(send_data_path):
        print("No sender data!")
        return []

    send_data = []
    with open(send_data_path, 'r') as fp:
        for line in fp:
            if line.strip() == '^C':
                continue
            send_data.append(float(line.strip().split(': ')[0]))
    send_data = np.array(send_data) * 1000

    # Load recv*.txt for each receiver
    print("[+] Load recv*.txt for each receiver")
    latencies = []
    for i in range(1, num_receiver + 1):
        recv_data_path = os.path.join(data_dir, f'recv{i}.txt')
        if not os.path.exists(recv_data_path):
            latencies.append([])
            continue

        # Load recv.txt
        recv_data = []
        with open(recv_data_path, 'r') as fp:
            for line in fp:
                if line.strip() == '^C':
                    continue
                recv_data.append(float(line.strip().split(': ')[0]))
        recv_data = np.array(recv_data) * 1000

        latencies.append(recv_data[:1000] - send_data[:1000])

        print("Latency %d (ms): %f (avg), %f (std dev)" % (
            i, np.mean(latencies[-1]), np.std(latencies[-1])))
        print("  - min: %f, max: %f" % (
            np.min(latencies[-1]), np.max(latencies[-1])))

    return latencies


def main(data_dir, num_sender, num_receiver):
    latencies = process_data(data_dir, num_sender, num_receiver)

    # plot_latency(no_protection_latency, protection_latency)


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Insufficient arguments!')
        sys.exit(1)
    data_base_dir = sys.argv[1]
    num_sender = int(sys.argv[2])  # assume only one sender
    num_receiver = int(sys.argv[3])
    data_type = sys.argv[4]
    protection_type = sys.argv[5]

    if data_type not in ["can", "lidar"]:
        print('Wrong data type!')
        sys.exit(1)

    if protection_type not in ["base", "gatekeeper", "tesla"]:
        print('Wrong protection type!')
        sys.exit(1)

    data_dir = os.path.join(
        data_base_dir, "s%dr%d/%s_%s" % (
            num_sender, num_receiver, data_type, protection_type))

    print(f"Data dir: {data_dir}")

    main(data_dir, num_sender, num_receiver)
