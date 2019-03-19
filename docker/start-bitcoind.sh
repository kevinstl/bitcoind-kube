#!/bin/bash

#if [ ! -f "/tmp/bitcoin.conf" ];
#then
#    cp /bitcoin/.bitcoin/bitcoin.conf /tmp/
#fi
#
#cp /tmp/bitcoin.conf /bitcoin/.bitcoin/bitcoin.conf

rpcAuthLineNumber=$(grep -n rpcauth /bitcoin/.bitcoin/bitcoin.conf | head -n 1 | cut -d: -f1)
rpcAuth=$(/tmp/setup-rpc.sh | grep rpcauth)
#rpcAuth=$(echo "rpcauth=blah")

if [[ ${rpcAuthLineNumber} != "" ]]
then
    sed -i -e "${rpcAuthLineNumber}s/.*/${rpcAuth}/" /bitcoin/.bitcoin/bitcoin.conf

else
    echo "" >> /bitcoin/.bitcoin/bitcoin.conf
    echo ${rpcAuth} >> /bitcoin/.bitcoin/bitcoin.conf
fi

docker-entrypoint.sh btc_oneshot

