#!/bin/bash

DIR="$( cd "$( dirname "$( dirname "${BASH_SOURCE[0]}" )" )" && pwd )"
cd $DIR

APP=app-mook

PORT=5000

TMP=/var/tmp
RUN=/var/tmp # should be /var/run instead

ACCESS_LOG_FILE=$TMP/$APP-access.log
PID_FILE=$RUN/$APP.pid
STARTER_LOG_FILE=$TMP/$APP-starter.log
STATUS_FILE=$RUN/$APP.status

export PATH=$DIR/local/bin:$PATH
export PERL5LIB=$DIR/local/lib/perl5

if [[ ! -f $PID_FILE ]]; then
  start_server \
    --dir          $DIR \
    --port         $PORT \
    --pid-file     $PID_FILE \
    --log-file     $STARTER_LOG_FILE \
    --status-file  $STATUS_FILE \
    --daemonize \
    -- \
    plackup \
      --server     Starman \
      --app        bin/app.psgi \
      --env        development \
      --access-log $ACCESS_LOG_FILE
fi
