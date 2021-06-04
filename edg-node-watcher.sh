#!/bin/bash

# A simple script that checks if a substrate/edgeware node is running on the specified port. 
# If the url doesn't respond, this script tries to kill the process and restart it.

# How to use:
# Pass 2 arguments:
#   - Argument #1: port to monitor (5000,5001, etc)
#   - Argument #2: command to execute if service running on the given port is down/not responding

port=$1
lclhst="http://localhost"
url="${lclhst}:${port}"

echo "Monitoring service running for: $url"


while [ 1 -le 5 ]
do
  sleep 5

  dt=$(date '+%d/%m/%Y %H:%M:%S');

  if curl --output /dev/null --silent --head --fail "$url"; then
    echo "[$dt] -> $url is alive! :)"
  else
    echo "[$dt] -> $url is down ;("
    # find the process id and kill it 
    lsof -i :$port|tail -n +2|awk '{print $2}'|xargs -r kill

  fi

done
