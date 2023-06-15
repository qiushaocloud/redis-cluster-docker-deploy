#!/bin/bash

set -a
source .env
set +a

echo "start delete-all-svc sh"
CURR_DIR=`pwd`

echo 'run deploy-files delete-all-svc.sh'
cd $CURR_DIR/deploy-files
bash delete-all-svc.sh

echo "finsh delete-all-svc sh"