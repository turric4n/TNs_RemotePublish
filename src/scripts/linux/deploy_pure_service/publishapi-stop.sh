#!/bin/bash
SIGNAL=${SIGNAL:-TERM}
PIDS=$(ps ax | grep -i 'TNsRemotePublish' | grep -v grep | awk '{print $1}')

if [ -z "$PIDS" ]; then
  echo "No api server to stop"
  exit 1
else
  kill -s $SIGNAL $PIDS
fi
