#!/bin/bash

# Create a bash script for updating and upgrading
cat << 'EOF' > /usr/local/bin/apt-update-upgrade.sh
#!/bin/bash
apt update && apt upgrade -y
EOF

# Make the script executable
chmod +x /usr/local/bin/apt-update-upgrade.sh

# Create a systemd service file
cat << 'EOF' > /etc/systemd/system/apt-update-upgrade.service
[Unit]
Description=Daily apt update and upgrade

[Service]
Type=oneshot
ExecStart=/usr/local/bin/apt-update-upgrade.sh
EOF

# Create a systemd timer file
cat << 'EOF' > /etc/systemd/system/apt-update-upgrade.timer
[Unit]
Description=Runs apt-update-upgrade daily

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Reload systemd to recognize the new service and timer
systemctl daemon-reload

# Enable and start the timer
systemctl enable --now apt-update-upgrade.timer
