#!/usr/bin/env bash

set -e

CMD="$1"
SERVICE="$2"
CONF_FILE="/etc/application/db.conf"
SERVER_SCRIPT="/usr/local/bin/mock_server.py"
PID_FILE="/tmp/mock_server.pid"

usage() {
  echo "Usage: systemctl [start|stop|restart|status] db"
}

get_port() {
  grep -E '^[[:space:]]*port[[:space:]]*=' "$CONF_FILE" | cut -d= -f2 | tr -d '[:space:]'
}

start_service() {
  PORT=$(get_port)
  if [[ -z "$PORT" ]]; then
    echo "❌ Port not found in config"
    exit 1
  fi

  if [[ -f "$PID_FILE" ]]; then
    echo "⚠️ Service already running (PID: $(cat "$PID_FILE"))"
    return
  fi

  nohup python3 "$SERVER_SCRIPT" "$PORT" >/dev/null 2>&1 &
  echo $! > "$PID_FILE"
  echo "✅ Service db started on port $PORT"
}

stop_service() {
  if [[ -f "$PID_FILE" ]]; then
    kill "$(cat "$PID_FILE")" && rm -f "$PID_FILE"
    echo "🛑 Service db stopped"
  else
    echo "⚠️ Service not running"
  fi
}

status_service() {
  if [[ -f "$PID_FILE" ]]; then
    if ps -p "$(cat "$PID_FILE")" > /dev/null 2>&1; then
      PORT=$(get_port)
      echo "✅ Service db is running (port $PORT)"
    else
      echo "⚠️ PID file exists but process is not running"
    fi
  else
    echo "🛑 Service db is not running"
  fi
}

case "$CMD" in
  start)
    if [[ "$SERVICE" == "db" ]]; then
      start_service
    else usage; exit 2; fi
    ;;
  stop)
    if [[ "$SERVICE" == "db" ]]; then
      stop_service
    else usage; exit 2; fi
    ;;
  restart)
    if [[ "$SERVICE" == "db" ]]; then
      stop_service
      start_service
    else usage; exit 2; fi
    ;;
  status)
    if [[ "$SERVICE" == "db" ]]; then
      status_service
    else usage; exit 2; fi
    ;;
  *)
    echo "systemctl: unknown command"
    usage
    exit 2
    ;;
esac
exit 0