#!/bin/bash

DIR="$( cd "$( dirname "$( dirname "${BASH_SOURCE[0]}" )" )" && pwd )"
cd $DIR

cpanm --local-lib local --notest --installdeps .
