#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Date    : 2021-09-15 22:26:51

import os
import sys
import glob
import json

import scipy.optimize
import numpy as np
import matplotlib.pyplot as plt


def plot_hardness_vs_time(time_data_avgs, time_data_stds):
    n = len(time_data_avgs)
    x = np.arange(n)

    plt.figure(figsize=(13, 7))
    plt.rcParams.update({'font.size': 24})

    params = scipy.optimize.curve_fit(lambda t, a, b: a * np.exp(b * t), x, time_data_avgs)
    print(params)
    x2 = np.arange(0, n - 1 + 0.1, 0.1)
    y2 = params[0][0] * np.exp(params[0][1] * x2)

    plt.plot(x, time_data_avgs, linestyle='', marker='o', label='data')
    plt.plot(x2, y2, label='fitted curve')

    plt.xlabel('Hardness Level')
    plt.ylabel('Time (ms)')
    # plt.ylim(0, 17.5)

    plt.legend()
    plt.grid(True, axis='y', linestyle='--')
    plt.tight_layout()

    plt.show()
    # plt.savefig('crypto_puzzle_figure.png')


def process_data(data_dir):
    time_data_avgs = []
    time_data_stds = []
    for k in range(0, 13):
        data_file_path = os.path.join(data_dir, f"k_{k}_n_100.txt")

        # Starting from -1 to skip the first line
        first_line = True
        time_data = []
        with open(data_file_path, 'r') as fp:
            for line in fp:
                # Skip the first line
                if first_line:
                    first_line = False
                    continue

                items = line.strip().split(': ')
                time_data.append(float(items[1][:-2]))

        # s --> ms
        time_data = np.array(time_data) * 1000

        # Calculate
        time_data_avgs.append(np.mean(time_data))
        time_data_stds.append(np.std(time_data))
        print(f"Hardness level: {k}")
        print(f"Time (ms): {time_data_avgs[-1]} (avg), {time_data_stds[-1]} (std dev)")

    return time_data_avgs, time_data_stds


def main(crypto_puzzle_data_dir):
    time_data_avgs, time_data_stds = process_data(crypto_puzzle_data_dir)

    plot_hardness_vs_time(time_data_avgs, time_data_stds)


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Insufficient arguments!')
        sys.exit(1)
    crypto_puzzle_data_dir = sys.argv[1]
    main(crypto_puzzle_data_dir)
