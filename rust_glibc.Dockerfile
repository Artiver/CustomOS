FROM ubuntu:impish

WORKDIR /opt

ENV RUSTUP_DIST_SERVER="https://rsproxy.cn"
ENV RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"

RUN cat <<'EOF' > /etc/apt/sources.list
deb [trusted=yes] http://mirrors.ustc.edu.cn/ubuntu-old-releases/ubuntu impish main restricted universe multiverse
deb [trusted=yes] http://mirrors.ustc.edu.cn/ubuntu-old-releases/ubuntu impish-updates main restricted universe multiverse
deb [trusted=yes] http://mirrors.ustc.edu.cn/ubuntu-old-releases/ubuntu impish-security main restricted universe multiverse
deb [trusted=yes] http://mirrors.ustc.edu.cn/ubuntu-old-releases/ubuntu impish-backports main restricted universe multiverse
EOF

RUN apt update && apt -y install curl && curl -LO https://rsproxy.cn/rustup-init.sh && bash rustup-init.sh -y && rm -f rustup-init.sh

RUN cat <<'EOF' > /root/.cargo/config.toml
[source.crates-io] 
replace-with = 'rsproxy-sparse'
[source.rsproxy]
registry = "https://rsproxy.cn/crates.io-index"
[source.rsproxy-sparse]
registry = "sparse+https://rsproxy.cn/index/"
[registries.rsproxy]
index = "https://rsproxy.cn/crates.io-index"
[net]
git-fetch-with-cli = true
EOF

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

RUN apt -y install build-essential
RUN ["/bin/bash", "-ic", "rustup target add aarch64-unknown-linux-gnu"]
