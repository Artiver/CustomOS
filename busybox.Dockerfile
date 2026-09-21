FROM ubuntu:noble

WORKDIR /opt

RUN sed -i 's@//.*.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list.d/ubuntu.sources && apt update && apt install -y bzip2 build-essential libncurses-dev gcc-aarch64-linux-gnu gcc-powerpc64-linux-gnu

# make defconfig
# make menuconfig
# clean tc.c
# make LDFLAGS="-s -w -Wl,--build-id=none" -j 16

# make clean
# make LDFLAGS="-s -w -Wl,--build-id=none" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j 16
# make LDFLAGS="-s -w -Wl,--build-id=none" ARCH=powerpc64 CROSS_COMPILE=powerpc64-linux-gnu- -j 16
