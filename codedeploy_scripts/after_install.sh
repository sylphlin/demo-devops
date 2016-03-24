#!/bin/sh

LOG="/var/log/$APPLICATION_NAME.log"

# Install dependency packages
yum install -y epel-release
yum install -y nodejs npm

# Create log file if not existed
if [ ! -f "$LOG" ];
then
   touch $LOG
   chown centos:centos $LOG
fi

# Install packages by npm
cd /var/www/nodejs/$APPLICATION_NAME/
npm install

# Write config files for systemctl
SERVICE_FILE="/usr/lib/systemd/system/$APPLICATION_NAME.service"

echo "[Unit]" > $SERVICE_FILE
echo "Description=For $APPLICATION_NAME" >> $SERVICE_FILE
echo "After=network.target" >> $SERVICE_FILE
echo "" >> $SERVICE_FILE
echo "[Service]" >> $SERVICE_FILE
echo "PIDFile=/run/$APPLICATION_NAME" >> $SERVICE_FILE
echo "Restart=always" >> $SERVICE_FILE
echo "WorkingDirectory=/var/www/nodejs/$APPLICATION_NAME"  >> $SERVICE_FILE
echo "ExecStart=/usr/bin/node /var/www/nodejs/$APPLICATION_NAME/bin/www" >> $SERVICE_FILE
echo "User=centos" >> $SERVICE_FILE
echo "Group=centos" >> $SERVICE_FILE
echo "Environment=NODE_ENV=$DEPLOYMENT_GROUP_NAME" >> $SERVICE_FILE
echo "" >> $SERVICE_FILE
echo "[Install]" >> $SERVICE_FILE
echo "WantedBy=multi-user.target" >> $SERVICE_FILE

# Write logrotate files
LOGROTATE_FILE="/etc/logrotate.d/$APPLICATION_NAME"
echo "$LOG {" > $LOGROTATE_FILE
echo "    mothly" >> $LOGROTATE_FILE
echo "    rotate 4" >> $LOGROTATE_FILE
echo "    missingok" >> $LOGROTATE_FILE
echo "    notifempty" >> $LOGROTATE_FILE
echo "    compress" >> $LOGROTATE_FILE
echo "    copytruncate" >> $LOGROTATE_FILE
echo "}" >> $LOGROTATE_FILE

# Reload and Enable Services
systemctl daemon-reload
systemctl enable $APPLICATION_NAME
