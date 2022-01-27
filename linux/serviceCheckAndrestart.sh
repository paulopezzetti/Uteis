#!/bin/bash

SERVICENAME="elasticsearch"

systemctl is-active --quiet $SERVICENAME
STATUS=$?

if [[ "$STATUS" -ne "0" ]]; then
        service $SERVICENAME start
fi
