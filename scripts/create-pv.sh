#!/bin/bash

#ex: ./create-pv.sh minikube lightning-kube-testnet testnet

context=$1
namespace=$2
networkSuffix=$3
network=$4

echo "create-pv.sh"

echo "context: ${context}"
echo "namespace: ${namespace}"
echo "networkSuffix: ${networkSuffix}"
echo "network: ${network}"

kubeContextArg=""
if [[ ${context} != "" ]]
then
    kubeContextArg="--kube-context ${context}"
fi

namespaceArg=""
if [[ ${namespace} != "" ]]
then
    namespaceArg="--namespace ${namespace}"
fi


cat ./lightning-kube-pv.yaml | sed "s/\X_NETWORK_SUFFIX_X/${networkSuffix}/" | sed "s/\X_NETWORK_X/${network}/" | kubectl ${kubeContextArg} ${namespaceArg} create -f -
cat ./lightning-kube-pvc.yaml | sed "s/\X_NETWORK_SUFFIX_X/${networkSuffix}/" | kubectl ${kubeContextArg} ${namespaceArg} create -f -

#cat ./bitcoind-kube-pvc.yaml | sed "s/\X_NETWORK_SUFFIX_X/${networkSuffix}/" | kubectl ${kubeContextArg} ${namespaceArg} create -f -

#./create-pv.sh "" lightning-kube-simnet -simnet simnet