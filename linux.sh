#!/bin/bash

debian_13='Types: deb
URIs: http://mirrors.ustc.edu.cn/debian
Suites: trixie trixie-updates
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb
URIs: http://mirrors.ustc.edu.cn/debian-security
Suites: trixie-security
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg'

debian_12='Types: deb
URIs: http://mirrors.ustc.edu.cn/debian
Suites: bookworm bookworm-updates
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb
URIs: http://mirrors.ustc.edu.cn/debian-security
Suites: bookworm-security
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg'

debian_11='deb http://mirrors.ustc.edu.cn/debian/ bullseye main contrib non-free
deb http://mirrors.ustc.edu.cn/debian/ bullseye-updates main contrib non-free
deb http://mirrors.ustc.edu.cn/debian/ bullseye-backports main contrib non-free
deb http://mirrors.ustc.edu.cn/debian-security/ bullseye-security main contrib non-free'

ubuntu_22='deb http://mirrors.ustc.edu.cn/ubuntu/ jammy main restricted universe multiverse
deb http://mirrors.ustc.edu.cn/ubuntu/ jammy-security main restricted universe multiverse
deb http://mirrors.ustc.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
deb http://mirrors.ustc.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse'

ubuntu_20='deb http://mirrors.ustc.edu.cn/ubuntu/ focal main restricted universe multiverse
# deb-src http://mirrors.ustc.edu.cn/ubuntu/ focal main restricted universe multiverse
deb http://mirrors.ustc.edu.cn/ubuntu/ focal-security main restricted universe multiverse
# deb-src http://mirrors.ustc.edu.cn/ubuntu/ focal-security main restricted universe multiverse
deb http://mirrors.ustc.edu.cn/ubuntu/ focal-updates main restricted universe multiverse
# deb-src http://mirrors.ustc.edu.cn/ubuntu/ focal-updates main restricted universe multiverse
deb http://mirrors.ustc.edu.cn/ubuntu/ focal-backports main restricted universe multiverse
# deb-src http://mirrors.ustc.edu.cn/ubuntu/ focal-backports main restricted universe multiverse
# 预发布软件源，不建议启用
# deb http://mirrors.ustc.edu.cn/ubuntu/ focal-proposed main restricted universe multiverse
# deb-src http://mirrors.ustc.edu.cn/ubuntu/ focal-proposed main restricted universe multiverse'

centos_7='[base]
name=CentOS-$releasever - Base - mirrors.aliyun.com
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/$releasever/os/$basearch/
        http://mirrors.aliyuncs.com/centos/$releasever/os/$basearch/
        http://mirrors.cloud.aliyuncs.com/centos/$releasever/os/$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
 
#released updates 
[updates]
name=CentOS-$releasever - Updates - mirrors.aliyun.com
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/$releasever/updates/$basearch/
        http://mirrors.aliyuncs.com/centos/$releasever/updates/$basearch/
        http://mirrors.cloud.aliyuncs.com/centos/$releasever/updates/$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
 
#additional packages that may be useful
[extras]
name=CentOS-$releasever - Extras - mirrors.aliyun.com
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/$releasever/extras/$basearch/
        http://mirrors.aliyuncs.com/centos/$releasever/extras/$basearch/
        http://mirrors.cloud.aliyuncs.com/centos/$releasever/extras/$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
 
#additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-$releasever - Plus - mirrors.aliyun.com
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/$releasever/centosplus/$basearch/
        http://mirrors.aliyuncs.com/centos/$releasever/centosplus/$basearch/
        http://mirrors.cloud.aliyuncs.com/centos/$releasever/centosplus/$basearch/
gpgcheck=1
enabled=0
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
 
#contrib - packages by Centos Users
[contrib]
name=CentOS-$releasever - Contrib - mirrors.aliyun.com
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/$releasever/contrib/$basearch/
        http://mirrors.aliyuncs.com/centos/$releasever/contrib/$basearch/
        http://mirrors.cloud.aliyuncs.com/centos/$releasever/contrib/$basearch/
gpgcheck=1
enabled=0
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
'

kali='deb https://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main non-free contrib non-free-firmware
# deb-src https://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main non-free contrib non-free-firmware'

nodejs_registry='https://registry.npmmirror.com'
nodejs_disturl='https://mirrors.huaweicloud.com/nodejs'
python='https://mirrors.bfsu.edu.cn/pypi/web/simple'
go='https://mirrors.aliyun.com/goproxy/'
rustup='https://mirrors.tuna.tsinghua.edu.cn/rustup'

# 判断当前系统
function judge_os() {
    local os_dist=`lsb_release -a 2>/dev/null`
    if [[ $os_dist =~ "focal" ]];then
        return 1
    elif [[ $os_dist =~ "Kali" ]];then
        return 2
    elif [[ $os_dist =~ "CentOS" ]];then
        return 3
    elif [[ $os_dist =~ "jammy" ]];then
        return 4
    elif [[ $os_dist =~ "bullseye" ]];then
        return 5
    elif [[ $os_dist =~ "bookworm" ]];then
        return 6
    elif [[ $os_dist =~ "trixie" ]];then
        return 7
    fi
}

# 换源
function config_set_sources() {
judge_os
local os_result=$?
if [ ${os_result} -eq 1 ]; then
    echo "" > /etc/apt/sources.list
    cat > /etc/apt/sources.list << EOF
${ubuntu_20}
EOF
    touch ~/.hushlogin
    apt clean all
    apt update
    echo "Ubuntu20 换源完成"
elif [[ ${os_result} -eq 2 ]]; then
    timedatectl set-timezone "Asia/Shanghai"
    echo "" > /etc/apt/sources.list
    cat > /etc/apt/sources.list << EOF
${kali}
EOF
    apt clean all
    apt update
    echo "Kali 换源完成"
elif [[ ${os_result} -eq 3 ]]; then
    echo "" > /etc/yum.repos.d/CentOS-Base.repo
    cat > /etc/yum.repos.d/CentOS-Base.repo << EOF
${centos_7}
EOF
    yum clean all
    yum makecache
    echo "Centos7 换源完成"
elif [[ ${os_result} -eq 4 ]]; then
    echo "" > /etc/apt/sources.list
    cat > /etc/apt/sources.list << EOF
${ubuntu_22}
EOF
    touch ~/.hushlogin
    apt clean all
    apt update
    echo "Ubuntu22 换源完成"
elif [[ ${os_result} -eq 5 ]]; then
    echo "" > /etc/apt/sources.list
    cat > /etc/apt/sources.list << EOF
${debian_11}
EOF
    apt clean all
    apt update
    echo "Debian11 换源完成"
elif [[ ${os_result} -eq 6 ]]; then
    echo "" > /etc/apt/sources.list.d/debian.sources
    cat > /etc/apt/sources.list.d/debian.sources << EOF
${debian_12}
EOF
    apt clean all
    apt update
    echo "Debian12 换源完成"
elif [[ ${os_result} -eq 7 ]]; then
    echo "" > /etc/apt/sources.list.d/debian.sources
    cat > /etc/apt/sources.list.d/debian.sources << EOF
${debian_13}
EOF
    apt clean all
    apt update
    echo "Debian13 换源完成"
fi
}

# 安装oh-my-zsh
function config_install_zsh() {
    apt install -y zsh git
    chsh -s /bin/zsh
    chmod +x ./zsh_install.sh
    bash ./zsh_install.sh
}

# 安装ssh-server、vim
function config_install_software() {
    apt install -y openssh-server vim apt-transport-https ca-certificates curl gnupg2 software-properties-common python3-pip
    systemctl restart ssh && systemctl enable ssh
}

# 安装Docker
function config_install_docker() {
    judge_os
    local os_result=$?
    if [ ${os_result} -eq 1 ] || [ ${os_result} -eq 4 ];then
        echo "Ubuntu 安装Docker"
        curl -fsSL https://repo.huaweicloud.com/docker-ce/linux/ubuntu/gpg | apt-key add -
        add-apt-repository "deb [arch=amd64] https://repo.huaweicloud.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
        apt update && apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    elif [ ${os_result} -eq 2 ];then
        echo "Kali 安装Docker"
        apt install -y ca-certificates curl
        install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://mirrors.huaweicloud.com/docker-ce/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
        chmod a+r /etc/apt/keyrings/docker.asc
        echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://mirrors.huaweicloud.com/docker-ce/linux/debian trixie stable" | tee /etc/apt/sources.list.d/docker.list
        apt update && apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    elif [ ${os_result} -eq 3 ];then
        echo "Centos 安装Docker"
        yum install -y yum-utils device-mapper-persistent-data lvm2
        yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
        sed -i 's+download.docker.com+mirrors.aliyun.com/docker-ce+' /etc/yum.repos.d/docker-ce.repo
        yum makecache fast
        yum -y install docker-ce
    elif [ ${os_result} -eq 5 ] || [ ${os_result} -eq 6 ] || [ ${os_result} -eq 7 ];then
        echo "Debian 安装Docker"
        apt install -y ca-certificates curl
        install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://mirrors.huaweicloud.com/docker-ce/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
        chmod a+r /etc/apt/keyrings/docker.asc
        tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://mirrors.huaweicloud.com/docker-ce/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF
        apt update && apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    fi
    tee /etc/docker/daemon.json <<EOF
{
  "registry-mirrors": [
    "https://docker.1panel.live/",
    "https://docker.m.daocloud.io/",
    "https://docker.1ms.run/"
  ],
  "live-restore": true,
  "ipv6": true,
  "ip6tables": true,
  "fixed-cidr-v6": "fd00::/112",
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "500m",
    "max-file": "3"
  },
  "experimental": true
}
EOF
    systemctl daemon-reload && systemctl restart docker && systemctl enable docker
    # usermod -aG docker $USER
}

# 安装K8s
function config_install_k8s() {
    judge_os
    local os_result=$?
    if [ ${os_result} -eq 1 ] || [ ${os_result} -eq 4 ];then
        curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
        cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF
        apt-get update
        apt-get install -y kubelet kubeadm kubectl
    elif [[ ${os_result} -eq 3 ]]; then
        cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
        setenforce 0
        yum install -y kubelet kubeadm kubectl
        systemctl enable kubelet && systemctl start kubelet
    fi
}

# 开机进入命令行
function config_start() {
    systemctl set-default multi-user.target
    # systemctl set-default graphical.target
}

# 配置软件源
function config_software_resource() {
    # pip config set global.index-url https://mirrors.bfsu.edu.cn/pypi/web/simple
    cp -f ./python.conf /etc/pip.conf
    
    # uv
    mkdir /etc/uv
    cat > /etc/uv/uv.toml <<EOF
[[index]]
url = "https://mirrors.ustc.edu.cn/pypi/simple"
default = true
EOF
    echo "export UV_DEFAULT_INDEX=https://mirrors.ustc.edu.cn/pypi/simple" >> /etc/profile
    
    # nvm
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    echo "export NVM_NODEJS_ORG_MIRROR=https://mirrors.ustc.edu.cn/node" >> /etc/profile

    # maven
    cp -f ./maven.xml $(dirname $(which mvn))/../conf/settings.xml
    
    # golang
    go env -w GO111MODULE=on 2>/dev/null
    go env -w GOPROXY=${go} 2>/dev/null
    go env -w GONOSUMDB=* 2>/dev/null
    
    # nodejs
    npm config set registry ${nodejs_registry} 2>/dev/null
    npm config set disturl ${nodejs_disturl} 2>/dev/null
    # rust

    export RUSTUP_DIST_SERVER='https://mirrors.huaweicloud.com/rustup/'
    export RUSTUP_UPDATE_ROOT='https://mirrors.huaweicloud.com/rustup/rustup/'
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

    mkdir ~/.cargo/
    cat > ~/.cargo/config.toml <<EOF
[source.crates-io]
replace-with = 'ustc'

[source.ustc]
registry = "sparse+https://mirrors.ustc.edu.cn/crates.io-index/"

[registries.ustc]
index = "sparse+https://mirrors.ustc.edu.cn/crates.io-index/"
EOF

    # ruby
    gem sources # 列出默认源
    gem sources --remove https://rubygems.org/ # 移除默认源
    gem sources -a https://mirrors.ustc.edu.cn/rubygems/ # 添加科大源
}

function config_debian_custom() {
    # apt install -y fcitx fcitx-googlepinyin vim git curl
    # usermod -aG sudo debian
    
    # Rust
    export RUSTUP_DIST_SERVER=${rustup}
    export RUSTUP_UPDATE_ROOT=${rustup}
#     rustup default stable
    echo "export RUSTUP_DIST_SERVER=${rustup}" >> /etc/profile
    echo "export RUSTUP_UPDATE_ROOT=${rustup}" >> /etc/profile

    # tar Czxf /usr/local go1.25.5.linux-amd64.tar.gz
    # echo "export PATH=\$PATH:/usr/local/go/bin" >> /etc/profile

    # mkdir -p /usr/local/jdk8
    # tar Czxf /usr/local/jdk8 OpenJDK8U-jdk_x64_linux_hotspot_8u432b06.tar.gz --strip-components=1
    # echo "export JAVA_HOME=/usr/local/jdk8/" >> /etc/profile
    # echo "export JRE_HOME=\${JAVA_HOME}/jre" >> /etc/profile
    # echo "export CLASSPATH=.:\${JAVA_HOME}/lib:\${JRE_HOME}/lib:\${CLASSPATH}" >> /etc/profile
    # echo "export JAVA_PATH=\${JAVA_HOME}/bin:\${JRE_HOME}/bin" >> /etc/profile
    # echo "export PATH=\$PATH:\${JAVA_PATH}" >> /etc/profile

    # mkdir -p /usr/local/maven
    # tar Czxf /usr/local/maven apache-maven-3.9.11-bin.tar.gz --strip-components=1
    # echo "export PATH=\$PATH:/usr/local/maven/bin" >> /etc/profile

    # mkdir -p /usr/local/nodejs
    # tar Cxf /usr/local/nodejs node-v22.21.1-linux-x64.tar.xz --strip-components=1
    # echo "export PATH=\$PATH:/usr/local/nodejs/bin" >> /etc/profile
    
    vscode='code_1.111.0-1772846623_amd64.deb'
    dpkg -i ${vscode}

    # 设置fcitx
    # im-config

    # 只对github.com代理
    # git config --global http.https://github.com.proxy socks5://127.0.0.1:10808

    # 取消代理
    # git config --global --unset http.https://github.com.proxy)
}

function install_gtx_3060() {
    # https://www.nvidia.cn/drivers/details/259050/
    driver='NVIDIA-Linux-x86_64-580.142.run'
    echo "blacklist nouveau" > /etc/modprobe.d/blacklist-nvidia-nouveau.conf
    echo "options nouveau modeset=0" >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf
    apt install gcc g++ cmake pkg-config libglvnd-dev linux-headers-$(uname -r) -y
    service gdm3 stop
    chmod +x ./${driver}
    ./${driver}
    nvidia-smi
}

function start_clash_service() {
    cat > /etc/systemd/system/clash.service << EOF
[Unit]
Description=Clash - A rule-based tunnel in Go
Documentation=https://github.com/Dreamacro/clash/wiki
[Service]
User=debian
Group=debian
OOMScoreAdjust=-1000
ExecStart=/home/debian/Softwares/Clash/clash
Restart=on-failure
RestartSec=5
[Install]
WantedBy=multi-user.target
EOF
    systemctl enable clash.service
    systemctl start clash.service
}

function install_kali_softwares() {
    # rustscan
    unzip -d /usr/local/bin x86-linux-rustscan.zip
    # time
    apt install -y ntpsec-ntpdate
    ntpdate ntp.aliyun.com
    timedatectl set-timezone Asia/Shanghai
    # rockyou
    cd /usr/share/wordlists
    sudo gzip -d rockyou.txt.gz
    sudo apt install seclists
    cd -
}

# config_set_sources
# config_install_zsh
# config_install_software
# config_install_docker
# config_install_k8s
# config_start
# config_debian_custom
# config_software_resource
install_gtx_3060
# start_clash_service
exit 0

