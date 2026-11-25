#!/usr/bin/env bash
# Installation (als root): ./install.sh
set -euo pipefail
cd "$(dirname "$0")"
install -d /opt/n8n-agent
install -m 755 n8n-agent.sh /opt/n8n-agent/
[ -f /opt/n8n-agent/n8n-agent.env ] || install -m 600 n8n-agent.env.example /opt/n8n-agent/n8n-agent.env
install -m 644 n8n-agent-*.service n8n-agent-*.timer /etc/systemd/system/
systemctl daemon-reload
systemctl enable --now n8n-agent-check.timer n8n-agent-update.timer
echo "Fertig. Config anpassen: /opt/n8n-agent/n8n-agent.env"
echo "Test: /opt/n8n-agent/n8n-agent.sh status"
