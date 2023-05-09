FROM ubuntu:22.04 AS base

RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker
RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /build
ADD https://developer.arm.com/-/media/Files/downloads/gnu-rm/10-2020q4/gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2?revision=ca0cbf9c-9de2-491c-ac48-898b5bbc0443&la=en&hash=68760A8AE66026BCF99F05AC017A6A50C6FD832A /build/gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update \
    && apt-get install -y \
    tzdata \
    bzip2 \
    make \
    python3 \
    ca-certificates \
    nodejs \
    npm \
    git \
    openocd \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /build/bin && \
    tar -C /build/bin -xf /build/gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2
ENV PATH="/build/bin/gcc-arm-none-eabi-10-2020-q4-major/bin:$PATH"

RUN mkdir -p /src
WORKDIR /src
VOLUME /src
