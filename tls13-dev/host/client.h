/* client.h
 *
 * Copyright (C) 2006-2020 wolfSSL Inc.
 *
 * This file is part of wolfSSL.
 *
 * wolfSSL is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * wolfSSL is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1335, USA
 */


#ifndef WOLFSSL_CLIENT_H
#define WOLFSSL_CLIENT_H


THREAD_RETURN WOLFSSL_THREAD client_test(void* args);


static void tcp_connect_v2(SOCKET_T* sockfd, const char* ip, word16 port,
                                     int udp, int sctp, WOLFSSL* ssl)
{
    SOCKADDR_IN_T addr, local_addr;
    build_addr(&addr, ip, port, udp, sctp);
    build_addr(&local_addr, "192.168.1.100", 0, udp, sctp);
    if (udp) {
        wolfSSL_dtls_set_peer(ssl, &addr, sizeof(addr));
    }
    tcp_socket(sockfd, udp, sctp);
    if (bind(*sockfd, (const struct sockaddr*)&local_addr, sizeof(local_addr)) != 0) {
        perror("tcp connect bind failed");
        err_sys("tcp connect bind failed");
    }

    if (!udp) {
        if (connect(*sockfd, (const struct sockaddr*)&addr, sizeof(addr)) != 0)
            err_sys("tcp connect failed");
    }
}

//typedef struct ProtocolVersion {
//    byte major;
//    byte minor;
//} WOLFSSL_PACK ProtocolVersion;
//
//struct WOLFSSL_METHOD {
//    ProtocolVersion version;
//    byte            side;         /* connection side, server or client */
//    byte            downgrade;    /* whether to downgrade version, default no */
//};
#include "internal.h"

#endif /* WOLFSSL_CLIENT_H */
