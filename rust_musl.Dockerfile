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
ARG CONFIG="/root/.bashrc"
ARG VERSION="2026.08-1"
ARG SUFFIX=".tar.xz"
ARG X86_64="x86-64--musl--stable-${VERSION}"
ARG ARM64="aarch64--musl--stable-${VERSION}"
ARG ARM64_BE="aarch64be--musl--stable-${VERSION}"

ADD --chown=root:root ${X86_64}${SUFFIX} ${DIR}
ADD --chown=root:root ${ARM64}${SUFFIX} ${DIR}
ADD --chown=root:root ${ARM64_BE}${SUFFIX} ${DIR}

RUN echo && \
echo "export PATH=\$PATH:${DIR}/${X86_64}/bin" >> ${CONFIG} && \
echo "export PATH=\$PATH:${DIR}/${ARM64}/bin" >> ${CONFIG} && \
echo "export PATH=\$PATH:${DIR}/${ARM64_BE}/bin" >> ${CONFIG}

RUN apt -y install build-essential
RUN ["/bin/bash", "-ic", "rustup target add aarch64-unknown-linux-musl x86_64-unknown-linux-musl"]
