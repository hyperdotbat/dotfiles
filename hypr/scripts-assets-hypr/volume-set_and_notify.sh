#!/bin/bash
cd "$(dirname "$0")" || exit 1
./volume-set.sh $1 && ./volume-notify.sh