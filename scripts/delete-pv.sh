#!/bin/bash

context=$1
namespace=$2
networkSuffix=$3

echo "delete-pv.sh"

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

cat ./lightning-kube-pvc.yaml | sed "s/\X_NETWORK_SUFFIX_X/${networkSuffix}/" | kubectl ${kubeContextArg} ${namespaceArg} delete -f -

cat ./lightning-kube-pv.yaml | sed "s/\X_NETWORK_SUFFIX_X/${networkSuffix}/" | kubectl ${kubeContextArg} ${namespaceArg} delete -f -
