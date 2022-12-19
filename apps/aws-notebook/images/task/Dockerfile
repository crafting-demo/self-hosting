FROM ubuntu:22.04
RUN apt-get update && apt-get install -y openssh-server python3-pip && apt-get clean -y && \
    pip install ipykernel && \
    mkdir -p /run/sshd
CMD ["bash","-c","set -exu; mkdir -p ~/.ssh; echo ${PUBLIC_KEY} >> ~/.ssh/authorized_keys; /usr/sbin/sshd -D -f /etc/ssh/sshd_config"]
