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
    echo "⚠️ Service already running (PID: $(cat "$PID_FILE"))"
    return
  fi

  PORT=$(get_port)
  if [[ -z "$PORT" ]]; then
    echo "❌ Port not found in config"
    exit 1
  fi

  nohup python3 "$SERVER_SCRIPT" "$PORT" >/dev/null 2>&1 &
  echo $! > "$PID_FILE"
  echo "✅ Service db started on port $PORT"
}

stop_service() {
  if is_running; then
    kill "$(cat "$PID_FILE")" && rm -f "$PID_FILE"
    echo "🛑 Service db stopped"
  else
    echo "⚠️ Service not running"
    rm -f "$PID_FILE"  # удалить устаревший PID-файл, если он остался
  fi
}

status_service() {
  if is_running; then
    PORT=$(get_port)
    echo "✅ Service db is running (port $PORT, PID: $(cat "$PID_FILE"))"
  else
    echo "🛑 Service db is not running on correct port"
    clean_stale_pid
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
    echo "systemctl: unknown command"
    usage
    exit 2
    ;;
esac
