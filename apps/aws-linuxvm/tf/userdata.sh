#!/bin/bash
set -x

# Inject SSH authorized keys.
mkdir -p "${home_dir}/.ssh"
cat <<EOF >>"${home_dir}/.ssh/authorized_keys"
${authorized_keys}
EOF
chown -R ${user}:${group} "${home_dir}/.ssh"

# Install and start VSCode server
mkdir -p /opt/sandboxd/vscode
curl -sSLf '${vscode_server_pkg_url}' | tar -C /opt/sandboxd/vscode -zx
cat <<EOF >/etc/systemd/system/vscode-server.service
[Unit]
Description=VSCode Server
After=network.target

[Service]
Type=simple
User=${user}
Group=${group}
WorkingDirectory=${home_dir}
ExecStart=/opt/sandboxd/vscode/server.sh --host 0.0.0.0 --port ${vscode_server_port} --without-connection-token --disable-telemetry

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable vscode-server.service
systemctl start vscode-server.service
