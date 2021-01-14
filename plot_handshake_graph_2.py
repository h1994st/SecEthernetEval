#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 2020-08-17 13:59:55

import numpy as np
import matplotlib.pyplot as plt


def main():
    x = ['TLS 1.3', 'TLS 1.2', 'DTLS 1.2', 'IPsec', 'MACsec']

    N = len(x)
    width = 0.35

    # ./results/20210113
    key_exchange_time_avgs = np.array([0.365878, 0.810486, 0.984765, 0.000831, 2.932416]) * 1000
    key_exchange_time_stds = np.array([0.172562, 0.093401, 0.155039, 0.000105, 0.000329]) * 1000

    total_time_avgs = np.array([0.800180, 0.956309, 1.215186, 1.105013, 3.270009]) * 1000
    total_time_stds = np.array([0.208733, 0.178613, 0.222742, 0.086478, 0.111434]) * 1000

    total_packet_size_avgs = [2036.5, 1666.1, 2142.05, 2769.1, 5048.0]
    total_packet_size_stds = [0.921954, 1.135782, 1.160819, 1.044031, 0.0]

    ind = np.arange(N)

    plt.figure(figsize=(18, 7))
    plt.rcParams.update({'font.size': 24})

    plt.subplot(1, 2, 1)
    plt.bar(
        ind, key_exchange_time_avgs, width, label='Key exchange time',
        yerr=key_exchange_time_stds,
        error_kw=dict(elinewidth=6, ecolor='black'))
    plt.bar(
        ind + width, total_time_avgs, width, label='Total time',
        yerr=total_time_stds,
        error_kw=dict(elinewidth=6, ecolor='black'))

    for i in range(N):
        # plt.text(
        #     x=ind[i] - 0.3,
        #     y=key_exchange_time_avgs[i] + key_exchange_time_stds[i] + 0.1,
        #     s=str(round(key_exchange_time_avgs[i], 2)), size=18)
        plt.text(
            x=ind[i] + width - 0.3,
            y=total_time_avgs[i] + total_time_stds[i] + 0.1,
            s=str(round(total_time_avgs[i], 2)), size=18)

    plt.xticks(ind + width / 2, x)
    plt.xlabel('Protocols')

    plt.ylabel('Time (ms)')
    plt.ylim(0, 3500)

    plt.legend(loc='lower center', ncol=2, bbox_to_anchor=(0.5, 1))
    plt.grid(True, axis='y', linestyle='--')
    plt.tight_layout()

    plt.subplot(1, 2, 2)
    plt.bar(
        ind, total_packet_size_avgs, width,
        color='g', label='Total packet size',
        yerr=total_packet_size_stds,
        error_kw=dict(elinewidth=6, ecolor='black'))

    for i in range(N):
        plt.text(
            x=ind[i] - 0.3,
            y=total_packet_size_avgs[i] + total_packet_size_stds[i] + 3,
            s=str(round(total_packet_size_avgs[i], 2)), size=18)

    plt.xticks(ind, x)
    plt.xlabel('Protocols')

    plt.ylabel('Size (bytes)')
    plt.ylim(0, 5100)

    plt.legend(loc='lower center', ncol=2, bbox_to_anchor=(0.5, 1))
    plt.grid(True, axis='y', linestyle='--')
    plt.tight_layout()

    # plt.show()
    plt.savefig('handshake_figure.png')


if __name__ == '__main__':
    main()
