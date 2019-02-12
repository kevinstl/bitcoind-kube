#!/usr/bin/env bash

# exit from script if error was raised.
set -e

#cat ./lightning-kube-pv.yaml | sed "s/\X_NETWORK_SUFFIX_X/${networkSuffix}/" | kubectl ${kubeContextArg} ${namespaceArg} create -f -

#"supervisord", "-c", "/etc/supervisor/supervisord.conf"

supervisord -c /etc/supervisor/supervisord.conf

#echo "supervisord.conf: "
#cat /etc/supervisor/supervisord.conf | sed "s/\X_NETWORK_X/${NETWORK}/"

#cat /etc/supervisor/supervisord.conf | sed "s/\X_NETWORK_X/${NETWORK}/" | supervisord -c -
