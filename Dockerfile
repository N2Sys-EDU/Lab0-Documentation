FROM ubuntu:22.04

LABEL maintainer="leo.cao@stu.pku.edu.cn"

COPY sources.list.x86 /etc/apt/sources.list

RUN apt update && apt install \
        build-essential \
        cmake \
        gcc \
        g++ \
        ninja-build \
        vim \
        openssh-server \
        ca-certificates \
        curl \
        git \
        python3 \
        python3-pip \
        wget \
        pkg-config \
        libsqlite3-dev \
        libgsl-dev \
        bison \
        flex \
        bzip2 \
        sudo \
        --yes --force-yes \
        && echo 'root:123456' | chpasswd

COPY sshd_config.txt /etc/ssh/sshd_config

RUN useradd -m student && \
    echo 'student:123456' | chpasswd && \
    echo 'student ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

RUN su -c "mkdir /home/student/workspace" student
WORKDIR /home/student/workspace

RUN su -c "wget https://www.nsnam.org/releases/ns-allinone-3.38.tar.bz2 && tar -xjf ns-allinone-3.38.tar.bz2 && rm ns-allinone-3.38.tar.bz2" student

WORKDIR /home/student/workspace/ns-allinone-3.38/ns-3.38
RUN su -c "./ns3 configure --enable-examples --enable-tests && ./ns3 build -j $(nproc)" student

WORKDIR /home/student