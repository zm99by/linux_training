#!/usr/bin/env bash
set -e

CMD="$1"
SERVICE="$2"

usage() {
  echo "Usage: systemctl restart db"
  echo "Note: This is a mock systemctl command for training purposes."
}

if [[ "$CMD" == "restart" && ( "$SERVICE" == "db" || "$SERVICE" == "mockdb" ) ]]; then
  if grep -Eq '^[[:space:]]*port[[:space:]]*=[[:space:]]*5432[[:space:]]*$' /etc/application/db.conf; then
    echo "✅ Service db restarted on port 5432"
    echo "✅ Configuration is valid"
    exit 0
  else
    echo "❌ Configuration error: expected 'port=5432' in /etc/application/db.conf"
    usage
    exit 1
  fi
else
  echo "systemctl: unknown command"
  usage
  exit 2
fi
