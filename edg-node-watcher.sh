#!/bin/bash

# How to use:
# Pass 3 arguments:
#   - Argument #1: port to monitor (5000,5001, etc)
#   - Argument #2: path to node (/home/ubuntu/edgeware_node)
#   - Argument #3: base path for the node (alice, bob)


if [ $# -eq 0 ] 
then
  echo "Missing or invalid arguments, please see arguments format:" 
  echo
  echo
  echo   "- Argument #1: port to monitor (5000,5001, etc)"
  echo   "- Argument #2: path to node (/home/ubuntu/edgeware_node)"
  echo   "- Argument #3: base path for the node (alice, bob)"  
  exit
fi

port=$1
lclhst="http://localhost"
url="${lclhst}:${port}"

echo "Monitoring service running for: $url - $3"


while [ 1 -le 5 ]
do
  sleep 5
  dt=$(date '+%d/%m/%Y %H:%M:%S');

  # make a curl request with 5 sec timeout
  # max time to restart a node would be 5 secs + the time it takes to restart (around 2-3 secs)
  response=$(curl --max-time 5 --write-out '%{http_code}' --silent --output /dev/null "$url")
  echo "[$dt] -> Response recieved - $response"

  if [ $response -eq 000 ]; then
  #  echo is down, restart it yooo
  #fi
  #continue
  #if curl --output /dev/null --silent --head --fail "$url"; then
  #  echo "[$dt] -> $url is alive! :)"
  #else
    echo "[$dt] -> $url is down ;("
    # find the process id and kill it forcefully!!
    lsof -i :$port|tail -n +2|awk '{print $2}'|xargs -r kill -9
    cd $2

    echo "[$dt] -> restarring $3 at $1 again..."
    nohup ./run-$3.sh &
    echo "[$dt] -> successfully restarted $3 at $1...."

    cd 
  else
    echo "[$dt] -> $url is alive! :)"
  fi

done
