#!/bin/bash

#ex: ./deploy-helm.sh minikube lightning-kube 0.0.6 blah LoadBalancer 30080 testnet false

context=$1
namespace=$2
imageTag=$3
database=$4
serviceType=$5
nodePort=$6
network=$7
deployPvc=$8
memory=$9

echo "context: ${context}"
echo "namespace: ${namespace}"
echo "imageTag: ${imageTag}"
echo "database: ${database}"
echo "serviceType: ${serviceType}"
echo "nodePort: ${nodePort}"
echo "network: ${network}"
echo "deployPvc: ${deployPvc}"
echo "memory: ${memory}"


kubeContextArg=""
if [[ ${context} != "" ]]
then
    kubeContextArg="--kube-context ${context}"
fi

networkArg=""
if [[ ${network} != "" ]]
then
    networkArg="--set project.network=${network}"
fi

networkSuffix=""
if [[ ${network} != "" ]]
then
    networkSuffix="-${network}"
fi

networkSuffixArg=""
if [[ ${network} != "" ]]
then
    networkSuffixArg="--set project.networkSuffix=${networkSuffix}"
fi

namespaceArg=""
if [[ ${namespace} != "" ]]
then
    namespaceArg="--namespace ${namespace}${networkSuffix}"
fi

namespaceValueArg=""
if [[ ${namespace} != "" ]]
then
    namespaceValueArg="--set project.namespace=${namespace}${networkSuffix}"
fi

serviceTypeArg=""
if [[ ${serviceType} != "" ]]
then
    serviceTypeArg="--set service.type=${serviceType}"
fi

nodePortArg=""
if [[ ${nodePort} != "" ]]
then
    nodePortArg="--set service.nodePort=${nodePort}"
fi

#./undeploy-helm.sh "${context}" ${network}

kubectl create namespace ${namespace}${networkSuffix}

if [[ ${deployPvc} == "true" ]]
then
    cd ./scripts
    ./create-pv.sh  "${context}" "${namespace}${networkSuffix}" ${networkSuffix} ${network}
    cd ..
fi

memoryArg=""
if [[ ${memory} != "" ]]
then
    memoryArg="--set resources.limits.memory=${memory} --set resources.requests.memory=${memory}"
fi


helm ${kubeContextArg} ${namespaceArg} install -n lightning-kube-bitcoind${networkSuffix} --set database=${database} ${namespaceValueArg} ${serviceTypeArg} ${nodePortArg} ${networkArg} ${networkSuffixArg} ${memoryArg} --set image.tag=${imageTag} charts/lightning-kube-bitcoind


if [ $? -eq 0 ]
then
  echo "Deploy Success"
else
  echo "Deploy Error" >&2
fi


#./deploy-helm.sh minikube jx-local 0.0.1 cryptocurrency-services-local
#./deploy-helm.sh "" jx-local 0.0.1 cryptocurrency-services-local
#./deploy-helm.sh "" "" 0.0.1 cryptocurrency-services-local
