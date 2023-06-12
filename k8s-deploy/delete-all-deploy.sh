#!/bin/bash

set -a
source .env
set +a

echo "start delete-all-deploy sh"
CURR_DIR=`pwd`

echo 'run deploy-files delete-all-deploy.sh'
cd $CURR_DIR/deploy-files
bash delete-all-deploy.sh

echo "finsh delete-all-deploy sh"