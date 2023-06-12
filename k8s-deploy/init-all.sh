#!/bin/bash

set -a
source .env
set +a

echo "start init-all sh"
CURR_DIR=`pwd`

if [ $K8S_PV_NFS_SERVER ] && [ $K8S_PV_NFS_PATH ]; then
    echo 'run nfs-pv-pvc init-all-pv-pvc.sh'
    cd $CURR_DIR/nfs-pv-pvc
    bash init-all-pv-pvc.sh
else
    echo 'run hostpath-pv-pvc init-all-pv-pvc.sh'
    cd $CURR_DIR/hostpath-pv-pvc
    bash init-all-pv-pvc.sh
fi

echo 'run deploy-files init-all-deploy.sh'
cd $CURR_DIR/deploy-files
bash init-all-deploy.sh

echo "finsh init-all sh"