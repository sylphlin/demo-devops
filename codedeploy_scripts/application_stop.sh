#!/bin/sh

# Check if the cloud-aaa.service existed or not
if [ -f "/usr/lib/systemd/system/$APPLICATION_NAME.service" ];
then
   systemctl stop $APPLICATION_NAME
fi
