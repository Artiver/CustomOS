FROM ubuntu:noble

WORKDIR /opt

RUN sed -i 's@//.*.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list.d/ubuntu.sources && \
apt update && apt install -y bzip2 build-essential libncurses-dev

# https://toolchains.bootlin.com/toolchains.html
# https://gitlab.arm.com/tooling/gnu-toolchains-for-arm

ARG DIR="/root"
ARG VERSION="2026.08-1"
ARG SUFFIX=".tar.xz"
ARG X86_64="x86-64--musl--stable-${VERSION}"
ARG ARM64="aarch64--musl--stable-${VERSION}"
ARG ARM64_BE="aarch64be--musl--stable-${VERSION}"

ADD --chown=root:root ${X86_64}${SUFFIX} ${DIR}
ADD --chown=root:root ${ARM64}${SUFFIX} ${DIR}
ADD --chown=root:root ${ARM64_BE}${SUFFIX} ${DIR}

RUN echo && \
echo "export PATH=\$PATH:${DIR}/${X86_64}/bin" >> /root/.bashrc && \
echo "export PATH=\$PATH:${DIR}/${ARM64}/bin" >> /root/.bashrc && \
echo "export PATH=\$PATH:${DIR}/${ARM64_BE}/bin" >> /root/.bashrc

# make defconfig
# make menuconfig
# make LDFLAGS="-s -w -Wl,--build-id=none" ARCH=amd CROSS_COMPILE=x86_64-linux- -j $(nproc)

# make clean
# make LDFLAGS="-s -w -Wl,--build-id=none" ARCH=arm CROSS_COMPILE=aarch64-linux- -j $(nproc)
# make LDFLAGS="-s -w -Wl,--build-id=none" ARCH=arm CROSS_COMPILE=aarch64_be-linux- -j $(nproc)

