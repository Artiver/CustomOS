FROM ubuntu:jammy

WORKDIR /opt

RUN sed -i 's@//.*.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list.d/ubuntu.sources && apt update && apt install -y bzip2 build-essential libncurses-dev

# https://toolchains.bootlin.com/toolchains.html
# https://gitlab.arm.com/tooling/gnu-toolchains-for-arm
ARG DIR="/root"
ARG X86_64="x86-64--glibc--stable-2026.08-1"
ARG ARM64="aarch64--glibc--stable-2026.08-1"
ARG ARM64_BE="aarch64be--glibc--stable-2026.08-1"
ARG POWERPC64_E5500="powerpc64-e5500--glibc--stable-2026.08-1"

ADD ${X86_64}.tar.xz ${DIR}
ADD ${ARM64}.tar.xz ${DIR}
ADD ${ARM64_BE}.tar.xz ${DIR}
ADD ${POWERPC64_E5500}.tar.xz ${DIR}

RUN chown -R root:root /root && \
echo "export PATH=\$PATH:${DIR}/${X86_64}/bin" >> /root/.bashrc && \
echo "export PATH=\$PATH:${DIR}/${ARM64}/bin" >> /root/.bashrc && \
echo "export PATH=\$PATH:${DIR}/${ARM64_BE}/bin" >> /root/.bashrc && \
echo "export PATH=\$PATH:${DIR}/${POWERPC64_E5500}/bin" >> /root/.bashrc

# make defconfig
# make menuconfig

# make clean
# make LDFLAGS="-s -w -Wl,--build-id=none" ARCH=amd CROSS_COMPILE=x86_64-linux- -j $(nproc)
# make LDFLAGS="-s -w -Wl,--build-id=none" ARCH=arm CROSS_COMPILE=aarch64-linux- -j $(nproc)
# make LDFLAGS="-s -w -Wl,--build-id=none" ARCH=arm CROSS_COMPILE=aarch64_be-linux- -j $(nproc)
# make LDFLAGS="-s -w -Wl,--build-id=none" ARCH=powerpc64 CROSS_COMPILE=powerpc64-linux- -j $(nproc)
