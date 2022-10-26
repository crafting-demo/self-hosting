#!/bin/bash

set -ex

function fatal() {
    echo "$@" >&2
    exit 1
}

[[ "$(id -u)" == "0" ]] || fatal "Must run as root!"

if [[ -z "$1" ]];then
  echo "USAGE: sudo ./build_bash.sh SNAPSHOT_NAME"
  exit 0
fi

apt-get update
apt-get install -y openvpn jq python3-pip
pip install importlib-resources==5.8
pip install remote_ikernel
pip install jupyterlab
pip install notebook
curl -sSLf https://releases.hashicorp.com/terraform/1.2.8/terraform_1.2.8_linux_amd64.zip | funzip >/usr/local/bin/terraform
chmod a+rx /usr/local/bin/terraform
curl -sSLf -o /tmp/awscli.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
unzip -d /tmp -o /tmp/awscli.zip
/tmp/aws/install
cs snapshot create "$1" -f
