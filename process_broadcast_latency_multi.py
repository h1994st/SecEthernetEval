#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Date    : 2021-05-13 13:52:00

import os
import sys
import glob
import json

import numpy as np
import matplotlib.pyplot as plt


def plot_latency(no_protection_latency, protection_latency):
    x = np.arange(10, 101, 10)
    N = len(x)
    ind = np.arange(N)

    no_protection_latency_avgs = []
    no_protection_latency_stds = []
    protection_latency_avgs = []
    protection_latency_stds = []
    for i in range(N):
        no_protection_latency_avgs.append(
            np.mean(no_protection_latency[i]))
        no_protection_latency_stds.append(
            np.std(no_protection_latency[i]))
        protection_latency_avgs.append(
            np.mean(protection_latency[i]))
        protection_latency_stds.append(
            np.std(protection_latency[i]))

    width = 0.35

    plt.figure(figsize=(18, 7))
    plt.rcParams.update({'font.size': 24})

    # plt.bar(
    #     ind, no_protection_latency_avgs, width,
    #     # yerr=no_protection_latency_stds,
    #     # error_kw=dict(elinewidth=6, ecolor='black'),
    #     label='w/o protection')
    # plt.bar(
    #     ind + width, protection_latency_avgs, width,
    #     # yerr=protection_latency_stds,
    #     # error_kw=dict(elinewidth=6, ecolor='black'),
    #     label='w/ protection')

    # # for i in range(N):
    # #     plt.text(
    # #         x=ind[i] - 0.3,
    # #         y=no_protection_latency_avgs[i] + no_protection_latency_stds[i] + 0.1,
    # #         s=str(round(no_protection_latency_avgs[i], 2)), size=18)
    # #     plt.text(
    # #         x=ind[i] + width - 0.3,
    # #         y=protection_latency_avgs[i] + protection_latency_stds[i] + 0.1,
    # #         s=str(round(protection_latency_avgs[i], 2)), size=18)

    # plt.xticks(ind + width / 2, x)

    # plt.xlabel('Packet Interval (ms)')
    # plt.ylabel('Latency (ms)')

    # only plot latency overhead
    protection_latency_avgs = np.array(protection_latency_avgs)
    no_protection_latency_avgs = np.array(no_protection_latency_avgs)
    overhead = protection_latency_avgs - no_protection_latency_avgs
    plt.bar(
        ind, overhead,
        label='w/o protection')
    for i in range(N):
        plt.text(
            x=ind[i] - 0.2,
            y=overhead[i] + 0.002,
            s=str(round(overhead[i], 2)), size=18)
    plt.xticks(ind, x)
    plt.xlabel('Packet Interval (ms)')
    plt.ylabel('Latency overhead (ms)')

    # plt.legend(loc='lower center', ncol=2, bbox_to_anchor=(0.5, 1))
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
    print("  - min: %f, max: %f" % (np.min(latency), np.max(latency)))

    return latency


def main(no_protection_dir, protection_dir):
    no_protection_latency = []
    protection_latency = []
    for interval in range(10, 101, 10):
        data_dir = os.path.join(no_protection_dir, '%d_ms_interval' % interval)
        latency = process_data(data_dir)
        no_protection_latency.append(latency)

        data_dir = os.path.join(protection_dir, '%d_ms_interval' % interval)
        latency = process_data(data_dir)
        protection_latency.append(latency)

    plot_latency(no_protection_latency, protection_latency)


if __name__ == '__main__':
    if len(sys.argv) < 3:
        print('Insufficient arguments!')
        sys.exit(1)
    no_protection_data_dir = sys.argv[1]
    protection_data_dir = sys.argv[2]

    main(no_protection_data_dir, protection_data_dir)
