#!/bin/bash

set -a
source .env
set +a

echo "start apply-all-pv-pvc sh"
CURR_DIR=`pwd`

if [ $K8S_PV_NFS_SERVER ] && [ $K8S_PV_NFS_PATH ]; then
    echo 'run nfs-pv-pvc apply-all-pv-pvc.sh'
    cd $CURR_DIR/nfs-pv-pvc
    bash apply-all-pv-pvc.sh
else
    echo 'run hostpath-pv-pvc apply-all-pv-pvc.sh'
    cd $CURR_DIR/hostpath-pv-pvc
    bash apply-all-pv-pvc.sh
fi

echo "finsh apply-all-pv-pvc sh"