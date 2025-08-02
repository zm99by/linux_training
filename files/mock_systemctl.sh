#!/bin/bash

if [ "$1" == "restart" ] && [ "$2" == "mockdb" ]; then
    if grep -q "port=5432" /etc/application/db.conf; then
        echo "✅ Service mockdb restarted on port 5432"
        echo "✅ Configuration is valid"
    else
        echo "❌ Configuration error: expected port=5432"
    fi
else
    echo "systemctl: unknown command"
fi
echo "Usage: systemctl restart mockdb"
echo "Note: This is a mock systemctl command for training purposes."
echo "You can only restart the mockdb service with the correct configuration."
echo "Make sure to edit the configuration file before running this command."
echo "For more information, refer to the training documentation."
echo "📝 Remember to revert any changes made to the configuration file after completing the task.   "