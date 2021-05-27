FROM ubuntu:18.04

RUN apt -y update && \
    apt install -y vim wget git autoconf libtool make apt-utils pkg-config \
                   libpq-dev libnl-3-dev libnl-genl-3-dev libnl-route-3-dev \
                   libssl-dev libdbus-1-dev network-manager \
                   iproute2 bsdmainutils iperf3 \
                   strongswan libcharon-extra-plugins strongswan-pki \
                   libgmp-dev iptables module-init-tools sudo \
                   netcat tcpdump can-utils libpcap-dev && \
    useradd -m seceth && \
    echo seceth:seceth | chpasswd && \
    cp /etc/sudoers /etc/sudoers.bak && \
    echo 'seceth ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

WORKDIR /home/seceth
# wolfSSL
# https://github.com/wolfSSL/wolfssl/archive/v4.4.0-stable.tar.gz
RUN wget https://github.com/wolfSSL/wolfssl/archive/v4.4.0-stable.tar.gz && \
    tar -zxf v4.4.0-stable.tar.gz && \
    cd wolfssl-4.4.0-stable && \
    ./autogen.sh && \
    ./configure --enable-tls13 --enable-tlsv10 --enable-oldtls --enable-dtls \
                --enable-dtls-mtu --enable-hc128 --enable-rabbit \
                --enable-aesccm --enable-opensslall && \
    make && make install && \
    cd /home/seceth && \
    chown -R seceth:seceth ./wolfssl-4.4.0-stable && \
    ldconfig

# MACsec
# wpa_supplicant
COPY --chown=seceth:seceth ./macsec-confs/wpa_supplicant_build_config \
    /home/seceth/wpa_supplicant_build_config
RUN wget http://w1.fi/releases/wpa_supplicant-2.9.tar.gz && \
    tar -xzf wpa_supplicant-2.9.tar.gz && \
    cd wpa_supplicant-2.9/wpa_supplicant && \
    mv /home/seceth/wpa_supplicant_build_config .config && \
    make && make install && \
    cd /home/seceth && \
    chown -R seceth:seceth ./wpa_supplicant-2.9

# hostapd
COPY --chown=seceth:seceth ./macsec-confs/hostapd_build_config \
    /home/seceth/hostapd_build_config
RUN wget https://w1.fi/releases/hostapd-2.9.tar.gz && \
    tar -xzf hostapd-2.9.tar.gz && \
    cd hostapd-2.9/hostapd && \
    mv /home/seceth/hostapd_build_config .config && \
    make && make install && \
    cd /home/seceth && \
    chown -R seceth:seceth ./hostapd-2.9

# iperf3 with TLS
RUN git clone https://github.com/h1994st/iperf.git iperf-wolfssl --depth=1 && \
    cd iperf-wolfssl && \
    ./bootstrap.sh && \
    ./configure --without-openssl LIBS=-lwolfssl && make && \
    cd /home/seceth && \
    chown -R seceth:seceth ./iperf-wolfssl

# Copy certificates
COPY ./ipsec-strongswan-confs/alice/aliceRsaKey.pem /etc/ipsec.d/private
COPY ./ipsec-strongswan-confs/alice/aliceRsaCert.pem /etc/ipsec.d/certs
COPY ./ipsec-strongswan-confs/bob/bobRsaKey.pem /etc/ipsec.d/private
COPY ./ipsec-strongswan-confs/bob/bobRsaCert.pem /etc/ipsec.d/certs
COPY ./ipsec-strongswan-confs/caCert.pem /etc/ipsec.d/cacerts

COPY ./ipsec-strongswan-confs/alice/aliceEcc256Key.pem /etc/ipsec.d/private
COPY ./ipsec-strongswan-confs/alice/aliceEcc256Cert.pem /etc/ipsec.d/certs
COPY ./ipsec-strongswan-confs/bob/bobEcc256Key.pem /etc/ipsec.d/private
COPY ./ipsec-strongswan-confs/bob/bobEcc256Cert.pem /etc/ipsec.d/certs
COPY ./ipsec-strongswan-confs/caEcc256Cert.pem /etc/ipsec.d/cacerts

USER seceth
