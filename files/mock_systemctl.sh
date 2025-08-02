#!/usr/bin/env bash
set -e

CMD="$1"
SERVICE="$2"

CONF_FILE="/etc/application/db.conf"
SERVER_SCRIPT="/usr/local/bin/mock_server.py"
PID_FILE="/var/log/mockdb/mock_server.pid"
LOG_FILE="/var/log/mockdb/mock_server.log"

usage() {
  echo "Usage: systemctl [start|stop|restart|status] db"
}

get_port() {
  grep -E '^[[:space:]]*port[[:space:]]*=' "$CONF_FILE" | cut -d= -f2 | tr -d '[:space:]'
}

is_running() {
  [[ -f "$PID_FILE" ]] && ps -p "$(cat "$PID_FILE")" > /dev/null 2>&1
}

clean_stale_pid() {
  if [[ -f "$PID_FILE" ]] && ! is_running; then
    rm -f "$PID_FILE"
  fi
}

start_service() {
  clean_stale_pid

  if is_running; then
    echo "Starting db.service..."
    echo "[  OK  ] db.service already running (PID: $(cat "$PID_FILE"))"
    return
  fi

  PORT=$(get_port)
  if [[ -z "$PORT" ]]; then
    echo "[FAILED] No port found in config"
    exit 1
  fi

  mkdir -p "$(dirname "$PID_FILE")"
  nohup python3 "$SERVER_SCRIPT" "$PORT" > "$LOG_FILE" 2>&1 &
  echo $! > "$PID_FILE"
  sleep 0.3

  if ! is_running; then
    echo "[FAILED] Failed to start db.service. Check $LOG_FILE"
    rm -f "$PID_FILE"
    exit 1
  fi

  echo "Starting db.service..."
  echo "[  OK  ] Started db.service"
}

stop_service() {
  if is_running; then
    kill "$(cat "$PID_FILE")" && rm -f "$PID_FILE"
    echo "Stopping db.service..."
    echo "[  OK  ] Stopped db.service"
  else
    echo "Stopping db.service..."
    echo "[WARNING] db.service is not running"
    rm -f "$PID_FILE" 2>/dev/null || true
  fi
}

status_service() {
  echo "● db.service - Mock Database Service"
  echo "   Loaded: loaded ($SERVER_SCRIPT; enabled)"

  if is_running; then
    PID=$(cat "$PID_FILE")
    PORT=$(get_port)
    echo "   Active: active (running)"
    echo "   Main PID: $PID (python3)"
    echo "   Port: $PORT"
    echo "   Logs: $LOG_FILE"
  else
    echo "   Active: inactive (dead)"
  fi
}

case "$CMD" in
  start)
    [[ "$SERVICE" == "db" ]] && start_service || (usage; exit 2)
    ;;
  stop)
    [[ "$SERVICE" == "db" ]] && stop_service || (usage; exit 2)
    ;;
  restart)
    [[ "$SERVICE" == "db" ]] && { stop_service; start_service; } || (usage; exit 2)
    ;;
  status)
    [[ "$SERVICE" == "db" ]] && status_service || (usage; exit 2)
    ;;
  *)
    echo "systemctl: unknown command: $CMD"
    usage
    exit 2
    ;;
esac
