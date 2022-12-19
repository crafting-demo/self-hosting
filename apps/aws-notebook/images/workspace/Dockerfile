FROM ubuntu:22.04
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata locales locales-all sudo && \
    update-locale LANG=en_US.UTF-8 && \
    sed -i -r 's/^(%sudo\s).+$/\1ALL=(ALL) NOPASSWD:ALL/g' /etc/sudoers && \
    (echo y && echo y) | DEBIAN_FRONTEND=noninteractive unminimize && \
    apt-get install -y \
        bash-builtins \
        bash-completion \
        ca-certificates \
        gpg \
        xz-utils \
        nano \
        vim-nox \
        emacs-nox \
        git \
        curl \
        wget \
        socat \
        telnet \
        netcat \
        man-db \
        zip p7zip \
        tmux \
        screen \
        tree \
        jq \
        cmake \
        make \
        autoconf \
        pkg-config \
        build-essential \
        gdb gdbserver \
        clang \
        clangd \
        llvm \
        virtualenv \
        python3-pip \
        openssh-client \
        openssh-server \
        openvpn \
        hexedit \
        iproute2 \
        tcpdump \
        iptables \
        iputils-ping \
        iputils-arping \
        iputils-tracepath \
        rsync \
        strace \
        zsh \
        redis-tools \
        mysql-client \
        postgresql-client && \
        apt-get clean -y
RUN pip install importlib-resources==5.8 remote_ikernel jupyterlab notebook && \
    curl -sSLf https://releases.hashicorp.com/terraform/1.3.6/terraform_1.3.6_linux_amd64.zip | funzip >/usr/local/bin/terraform && chmod a+rx /usr/local/bin/terraform && \
    curl -sSLf -o /tmp/awscli.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip && unzip -d /tmp -o /tmp/awscli.zip && /tmp/aws/install && rm -fr /tmp/aws /tmp/awscli.zip
