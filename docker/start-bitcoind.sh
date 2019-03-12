#!/bin/bash

/tmp/setup-rpc.sh | grep rpcauth >> /bitcoin/.bitcoin/bitcoin.conf

docker-entrypoint.sh btc_oneshot

