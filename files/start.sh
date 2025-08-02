#!/usr/bin/env bash
set -e

cat <<'MSG'
🧪 Welcome to Linux CLI Training

Your task:
  🔹 Locate the application configuration file
  🔹 Change the port number to the correct one
  🔹 Fix the file permissions → modify the port → (optionally) revert permissions
  🔹 After editing, use: systemctl restart db

Bonus commands:
  • systemctl start db      → Start the service
  • systemctl stop db       → Stop it
  • systemctl status db     → Check if it’s running
  • systemctl restart db    → Restart with updated config

Hints:
  • Find the config file: db.conf
  • Check the config file permissions
  • Test it: curl http://localhost:5432

📘 Note: The server must be running on port 5432 to return a secret sentence.

Good luck!
MSG

# Start interactive shell
exec bash -l

