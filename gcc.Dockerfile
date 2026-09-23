FROM ubuntu:noble

WORKDIR /opt

RUN sed -i 's@//.*.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list.d/ubuntu.sources && apt update && apt install -y bzip2 build-essential libncurses-dev gcc-powerpc64-linux-gnu gcc-riscv64-linux-gnu 

# https://toolchains.bootlin.com/toolchains.html
# https://gitlab.arm.com/tooling/gnu-toolchains-for-arm
ARG DIR="/root"
ARG ARM64="arm-gnu-toolchain-15.3.rel1-x86_64-aarch64-none-linux-gnu"
ARG ARM64_BE="arm-gnu-toolchain-15.3.rel1-x86_64-aarch64_be-none-linux-gnu"
ADD ${ARM64}.tar.xz ${DIR}
ADD ${ARM64_BE}.tar.xz ${DIR}

RUN chown -R root:root /root && echo "export PATH=\$PATH:${DIR}/${ARM64}/bin:${DIR}/${ARM64_BE}/bin" >> /root/.bashrc

# linux kenerl > 6 then rm networking/tc.c
# make defconfig
# make menuconfig
# make LDFLAGS="-s -w -Wl,--build-id=none" -j 16

# make clean
# make LDFLAGS="-s -w -Wl,--build-id=none" ARCH=arm CROSS_COMPILE=aarch64-linux-gnu- -j 16
# make LDFLAGS="-s -w -Wl,--build-id=none" ARCH=arm CROSS_COMPILE=aarch64_be-none-linux-gnu- -j 16
# make LDFLAGS="-s -w -Wl,--build-id=none" ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- -j 16
# make LDFLAGS="-s -w -Wl,--build-id=none" ARCH=powerpc64 CROSS_COMPILE=powerpc64-linux-gnu- -j 16
