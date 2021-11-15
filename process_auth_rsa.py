#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
import glob
import json

import numpy as np
import matplotlib.pyplot as plt


def plot_cdf(latency):
    # H, X1 = np.histogram(latency, bins=10, normed=True)
    # dx = X1[1] - X1[0]
    # F1 = np.cumsum(H)*dx

    N = len(latency)
    X2 = np.sort(latency)
    F2 = np.array(range(N))/float(N)

    plt.rcParams.update({'font.size': 12})

    # plt.plot(X1[1:], F1)
    plt.plot(X2, F2)

    plt.xlabel('Latency (ms)')
    plt.grid(True, axis='x', linestyle='--')
    plt.tight_layout()

    plt.show()


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


def process_data(data_dir):
    # Load send.txt
    print("[+] Load auth.txt")
    auth_data_path = os.path.join(data_dir, 'auth.txt')
    if not os.path.exists(auth_data_path):
        print("No authenticator data!")
        return []

    auth_data = []
    start_txt = " mitm_auth: before crypto_akcipher_sign"
    end_txt = " mitm_auth: crypto_akcipher_sign ret: 0"
    with open(auth_data_path, 'r') as fp:
        lines = fp.readlines()

    i = 0
    while i < len(lines):
        line = lines[i]
        i += 1
        if line.strip() == '^C':
            continue
        if start_txt not in line:
            continue

        # Found the start line
        next_line = lines[i]
        start_ts = float(line.strip().split("] ")[0][1:])
        end_ts = float(next_line.strip().split("] ")[0][1:])

        auth_data.append(end_ts - start_ts)

        # Skip one more line
        i += 1
    auth_data = np.array(auth_data) * 1000

    print("Latency (ms): %f (avg), %f (std dev)" % (
        np.mean(auth_data[-1]), np.std(auth_data[-1])))
    print("  - min: %f, max: %f" % (
        np.min(auth_data[-1]), np.max(auth_data[-1])))

    return auth_data


def main(data_dir):
    latency = process_data(data_dir)

    plot_cdf(latency)

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

    if protection_type not in ["base", "gatekeeper", "gatekeeper_rsa", "tesla"]:
        print('Wrong protection type!')
        sys.exit(1)

    data_dir = os.path.join(
        data_base_dir, "s%dr%d/%s_%s" % (
            num_sender, num_receiver, data_type, protection_type))

    print(f"Data dir: {data_dir}")

    main(data_dir)
