nodeName=redis-cluster-node-6373
if [ "$1" != "" ]; then
    nodeName=$1
fi
echo "nodeName: $nodeName"

docker exec -it $nodeName bash
