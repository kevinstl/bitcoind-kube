#!/bin/bash

#MINING_ADDRESS

context=$1
namespace=$2

kubectl --context=${context} --namespace ${namespace} delete -f ./secrets.yml


#./delete-secrets.sh minikube lightning-kube