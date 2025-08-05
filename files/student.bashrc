# ~/.bashrc — customized for Linux CLI training

# prompt
export PS1="\[\e[32m\]\u@linux-lab:\w\$ \[\e[0m\]"

# Welcome banner
if [[ $- == *i* ]]; then
  cat <<'EOF'

👋 Welcome to the Linux CLI Training Lab!

Your task:
  🔹 Locate the application configuration file
  🔹 Change the port number to the correct one
  🔹 Fix the file permissions → modify the port → (optionally) revert permissions
  🔹 After editing, use: systemctl restart db

Hints:
  • Find the config file: db.conf
  • Check the config file permissions
  • Test it: curl http://localhost:5432

EOF
fi
