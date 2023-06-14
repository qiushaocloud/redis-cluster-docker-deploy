#!/bin/bash

kubectl create ns redis
kubectl apply -f redis-cluster-create-job.yaml