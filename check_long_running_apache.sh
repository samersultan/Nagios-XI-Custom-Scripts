################################################################################
#
#		Check Apache Logs for Long running Transactions by application
#
#		$1 - App URI - Requred - URI path to check logs for
#
#		$2 - Minutes - Optional - How far back in the log are we looking at
#							timestamps, defaults to 75 minutes
#
#		$3 - Limit - How many milliseconds should a transaction take before
#							alerting, defaults to 240000 ms (4 minutes)
#
################################################################################

#!/bin/bash
appURI=$1
minutes=$2
limit=$3

if [ -z $minutes ]; then
minutes=75;
fi

if [ -z $limit ]; then
limit=240000;
fi

today=`date +%Y-%m-%d`
dateToCheck=$(date -d"now-${minutes} minutes" +[%d/%b/%Y:%H:%M:%S)

out=`awk -vappURI="$appURI" -vDate=$dateToCheck -vsecondLimit=$limit '{ \
 if ($1 > Date) \
 { \
  split($NF,m,":"); \
  if (m[2] > secondLimit && $(NF-4) !~ /\/ws\// && $(NF-4)~appURI) \
  print $0; \
 } \
}' /apps/httpd/logs/ssl_request_log-$today`

if [ -z "${out}" ];
then
 echo "No Long Running Transactions with processing time greater than ${limit} seconds since: $dateToCheck"
 exit 0;
else
 echo "These transactions were found with processing time greater than ${limit} seconds since: $dateToCheck"
 echo "$out"
 exit 2;
fi
