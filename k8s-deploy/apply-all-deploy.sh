#!/bin/bash

set -a
source .env
set +a

echo "start apply-all-deploy sh"
CURR_DIR=`pwd`

echo 'run deploy-files apply-all-deploy.sh'
cd $CURR_DIR/deploy-files
bash apply-all-deploy.sh

echo "finsh apply-all-deploy sh"