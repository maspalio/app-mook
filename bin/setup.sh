#!/bin/bash

DIR="$( cd "$( dirname "$( dirname "${BASH_SOURCE[0]}" )" )" && pwd )"
cd $DIR

cat app-schema.sql | sqlite3 app.db
cat app-data.sql   | sqlite3 app.db
