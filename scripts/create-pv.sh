#!/bin/bash

context=$1
namespace=$2
networkSuffix=$3

echo "create-pv.sh"

echo "context: ${context}"
echo "namespace: ${namespace}"
echo "networkSuffix: ${networkSuffix}"

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


cat ./lightning-kube-pv.yaml | sed "s/\X_NETWORK_SUFFIX_X/${networkSuffix}/" | kubectl ${kubeContextArg} ${namespaceArg} create -f -

cat ./lightning-kube-pvc.yaml | sed "s/\X_NETWORK_SUFFIX_X/${networkSuffix}/" | kubectl ${kubeContextArg} ${namespaceArg} create -f -

