#!/usr/bin/env bash
set -e

cat <<'MSG'
🧪 Linux CLI Training

Your task:
  🔹 Locate the application configuration file
  🔹 Change the port number to the correct one: 5432
  🔹 Oops! No write permission?
  🔹 Fix the file permissions → modify the port → (optionally) revert permissions
  🔹 After editing, use: systemctl restart db

Bonus commands:
  • systemctl start db      → Start the mock service
  • systemctl stop db       → Stop it
  • systemctl status db     → Check if it’s running
  • systemctl restart db    → Restart with updated config

Hints:
  • Config file: /etc/application/db.conf
  • Check file permissions: ls -l /etc/application/db.conf
  • Temporarily allow editing: sudo chmod u+w /etc/application/db.conf
  • Editor: vi /etc/application/db.conf
  • Test it: curl http://localhost:5432

📘 Note: The server must be running on port 5432 to return a secret.

Good luck!
MSG

# Start interactive shell
exec bash -l

