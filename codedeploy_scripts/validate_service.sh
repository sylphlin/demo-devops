#!/bin/sh

LOG=`systemctl status $APPLICATION_NAME`
RESULT=`systemctl status $APPLICATION_NAME | sed -n 's/[ ]*Active: \(.*\) (.*/\1/p'`

if [[ "$RESULT" =~ "active" ]]; then
    printf "$LOG"
    exit 0
else
    printf "$LOG"
    exit 1
fi
