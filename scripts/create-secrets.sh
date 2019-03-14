#!/bin/bash

#MINING_ADDRESS

context=$1
namespace=$2
network=$3
miningAddress=`echo -n $4 | base64`
rpcuser=`echo -n $5 | base64`
rpcpass=`echo -n $6 | base64`

echo "encrypted miningAddress: ${miningAddress}"


networkSuffix=""
if [[ ${network} != "" ]]
then
    networkSuffix="-${network}"
fi

namespaceArg=""
if [[ ${namespace} != "" ]]
then
    namespaceArg="--namespace ${namespace}${networkSuffix}"
fi

echo "miningAddress: ${miningAddress}"

cat ./secrets.yml | sed "s/\X_MINING_ADDRESS_X/${miningAddress}/" | \
                    sed "s/\X_RPCUSER_X/${rpcuser}/" | \
                    sed "s/\X_RPCPASS_X/${rpcpass}/" | \
                    kubectl --context=${context} ${namespaceArg} create -f -

#cat ./secrets.yml | sed "s/\X_MINING_ADDRESS_X/${miningAddress}/"


#./create-secrets.sh minikube lightning-kube mainnet empty devuser_change devpass_change
#./create-secrets.sh minikube lightning-kube simnet empty devuser_change devpass_change
#./create-secrets.sh minikube lightning-kube regtest empty devuser_change devpass_change