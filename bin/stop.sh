#!/bin/bash

APP=app-mook

RUN=/var/tmp # should be /var/run

PID_FILE=$RUN/$APP.pid

if [[ -f $PID_FILE ]]; then
  kill -SIGTERM $( cat $PID_FILE ) && rm -f $PID_FILE
fi
