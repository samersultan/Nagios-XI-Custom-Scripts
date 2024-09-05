################################################################################
#
#       Check for and alert when a server is turned on / off
#
#
################################################################################



#!/bin/bash

# Nagios return codes
OK=0
WARNING=1
CRITICAL=2
UNKNOWN=3

# Check uptime
UPTIME=$(uptime -p 2>/dev/null)

if [ $? -ne 0 ]; then
    echo "CRITICAL: Server is OFFLINE or not reachable."
    exit $CRITICAL
else
    echo "OK: Server is ONLINE. Uptime: $UPTIME"
    exit $OK
fi
