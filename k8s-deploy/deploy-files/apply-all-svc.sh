#!/bin/bash

kubectl create ns redis
kubectl apply -f redis-cluster-svc.yaml