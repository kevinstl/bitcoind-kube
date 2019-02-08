#!/bin/bash

#MINING_ADDRESS

context=$1
namespace=$2

miningAddress=`echo $3 | base64`

echo "encrypted miningAddress: ${miningAddress}"

cat ./secrets.yml | sed "s/\X_MINING_ADDRESS_X/${miningAddress}/" | kubectl --context=${context} --namespace ${namespace} create -f -

#cat ./secrets.yml | sed "s/\X_MINING_ADDRESS_X/${miningAddress}/"


#./create-secrets.sh minikube lightning-kube rb6CBeh9F2z149iDP19xNV4Mgr8SQFbkFc
#./create-secrets.sh minikube lightning-kube empty