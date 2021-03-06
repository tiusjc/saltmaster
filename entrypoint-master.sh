#!/bin/bash

# Start the first process
/usr/bin/salt-master -d -l debug
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start salt-master: $status"
  exit $status
fi

# Start the second process
usr/bin/salt-api -d -l debug
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start salt-api: $status"
  exit $status
fi

# Naive check runs checks once a minute to see if either of the processes exited.
# This illustrates part of the heavy lifting you need to do if you want to run
# more than one service in a container. The container exits with an error
# if it detects that either of the processes has exited.
# Otherwise it loops forever, waking up every 60 seconds

while sleep 60; do
  ps aux |grep salt-master |grep -q -v grep
  PROCESS_1_STATUS=$?
  ps aux |grep salt-api |grep -q -v grep
  PROCESS_2_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_1_STATUS -ne 0 ]; then
    echo "Processe one has already exited."
    exit 1
  fi
  if [ $PROCESS_2_STATUS -ne 0 ]; then
    echo "Processe two has already exited."
    exit 1
  fi
done
