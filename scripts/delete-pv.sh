#!/bin/bash

context=$1
namespace=$2
networkSuffix=$3
network=$4
deployEnv=$5

echo "delete-pv.sh"

echo "context: ${context}"
echo "namespace: ${namespace}"
echo "networkSuffix: ${networkSuffix}"
echo "network: ${network}"
echo "deployEnv: ${deployEnv}"

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

cat ./lightning-kube-pvc.yaml | sed "s/\X_NETWORK_SUFFIX_X/${networkSuffix}/" | sed "s/\X_NETWORK_X/${network}/" | kubectl ${kubeContextArg} ${namespaceArg} delete -f -

if [[ ${deployEnv} != "gke" ]]
then
    cat ./lightning-kube-pv.yaml | sed "s/\X_NETWORK_SUFFIX_X/${networkSuffix}/" | kubectl ${kubeContextArg} ${namespaceArg} delete -f -
fi

#cat ./bitcoind-kube-pvc.yaml | sed "s/\X_NETWORK_SUFFIX_X/${networkSuffix}/" | kubectl ${kubeContextArg} ${namespaceArg} delete -f -


#./delete-pv.sh "" lightning-kube-simnet -simnet simnet gke