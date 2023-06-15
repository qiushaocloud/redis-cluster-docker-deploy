#!/bin/bash

set -a
source .env
set +a

echo "start apply-all-svc sh"
CURR_DIR=`pwd`

echo 'run deploy-files apply-all-svc.sh'
cd $CURR_DIR/deploy-files
bash apply-all-svc.sh

echo "finsh apply-all-svc sh"