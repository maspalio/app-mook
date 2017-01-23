#!/bin/bash

APP=app-mook

RUN=/var/tmp # should be /var/run

PID_FILE=$RUN/$APP.pid

if [[ -f $PID_FILE ]]; then
  ps -elf | grep $( cat $PID_FILE ) | fgrep -v grep
fi
