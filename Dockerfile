# Use Ubuntu 22.04 as the base image
FROM ubuntu:jammy

ENV DEBIAN_FRONTEND=noninteractive

# Set up sources and install dependencies
RUN echo "deb http://archive.ubuntu.com/ubuntu jammy main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb http://archive.ubuntu.com/ubuntu jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://security.ubuntu.com/ubuntu jammy-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    vim \
    ca-certificates \
    libpcsclite1 \
    libusb-1.0-0 \
    libedit2 \
    libc6 \
    libcurl4 \
    libssl3 \
    && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /app

# Download and install YubiHSM SDK
RUN wget https://developers.yubico.com/YubiHSM2/Releases/yubihsm2-sdk-2024-09-ubuntu2404-amd64.tar.gz \
    && tar zxvfp *.gz \
    && cd yubihsm2* \
    && dpkg --force-depends -i ./libykhsmauth1_*.deb \
                             ./libyubihsm-usb1_*.deb \
                             ./libyubihsm-http1_*.deb \
                             ./libyubihsm1_*.deb \
                             ./yubihsm-shell_*.deb

CMD ["yubihsm-shell", "--version"]