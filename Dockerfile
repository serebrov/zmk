FROM ubuntu:20.04

WORKDIR /zmk

ENV TZ=Europe/Kiev
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update

RUN apt install -y \
    git \
    wget \
    autoconf \
    automake \
    build-essential \
    bzip2 \
    ccache \
    device-tree-compiler \
    dfu-util \
    g++ \
    gcc \
    libtool \
    make \
    ninja-build \
    cmake \
    python3-dev \
    python3-pip \
    python3-setuptools \
    xz-utils

RUN pip3 install -U west
RUN pip3 install -U pyelftools

ENV ZSDK_VERSION 0.11.4
RUN wget -q "https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${ZSDK_VERSION}/zephyr-toolchain-arm-${ZSDK_VERSION}-setup.run" && \
    sh "zephyr-toolchain-arm-${ZSDK_VERSION}-setup.run" --quiet -- -d ~/.local/zephyr-sdk-${ZSDK_VERSION} && \
    rm "zephyr-toolchain-arm-${ZSDK_VERSION}-setup.run"

CMD ["bash"]
