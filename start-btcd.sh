#!/usr/bin/env bash

# exit from script if error was raised.
set -e

# error function is used within a bash function in order to send the error
# message directly to the stderr output and exit.
error() {
    echo "$1" > /dev/stderr
    exit 0
}

# return is used within bash function in order to return the value.
return() {
    echo "$1"
}

# set_default function gives the ability to move the setting of default
# env variable from docker file to the script thereby giving the ability to the
# user override it durin container start.
set_default() {
    # docker initialized env variables with blank string and we can't just
    # use -z flag as usually.
    BLANK_STRING='""'

    VARIABLE="$1"
    DEFAULT="$2"

    if [[ -z "$VARIABLE" || "$VARIABLE" == "$BLANK_STRING" ]]; then

        if [ -z "$DEFAULT" ]; then
            error "You should specify default variable"
        else
            VARIABLE="$DEFAULT"
        fi
    fi

   return "$VARIABLE"
}

# Set default variables if needed.
RPCUSER=$(set_default "$RPCUSER" "devuser")
RPCPASS=$(set_default "$RPCPASS" "devpass")
DEBUG=$(set_default "$DEBUG" "info")
NETWORK=$(set_default "$NETWORK" "simnet")

baseDir="/mnt/lk/${NETWORK}"
basebitcoindDir=${baseDir}/bitcoind
baseRpcDir=${baseDir}/shared/rpc

PARAMS=$(echo \
    "--$NETWORK" \
    "--debuglevel=$DEBUG" \
    "--rpcuser=$RPCUSER" \
    "--rpcpass=$RPCPASS" \
    "--datadir=${basebitcoindDir}/data" \
    "--logdir=${basebitcoindDir}/log" \
    "--rpccert=${baseRpcDir}/rpc.cert" \
    "--rpckey=${baseRpcDir}/rpc.key" \
    "--rpclisten=0.0.0.0" \
    "--txindex"
)

# Set the mining flag only if address is non empty.
if [[ -n "$MINING_ADDRESS" ]]; then
    PARAMS="$PARAMS --miningaddr=$MINING_ADDRESS"
fi

# Add user parameters to command.
PARAMS="$PARAMS $@"

bitcoindHostName="lightning-kube-bitcoind.lightning-kube-$NETWORK"
bitcoindServiceIp=`ping ${bitcoindHostName} -c1 | head -1 | grep -Eo '[0-9.]{4,}'`

echo "bitcoindServiceIp: ${bitcoindServiceIp}"

#mkdir -p ${baseRpcDir}


#umask 000

echo "whoami: `whoami`"

#ls -Ral /mnt/lk
#sudo chmod -R 777 /mnt/lk
#ls -Ral /mnt/lk
#sudo chown -R root:root /mnt/lk
#chown -R root:root /mnt/lk

ls -Ral /mnt/lk

/bin/gencerts --host="*" --host="${bitcoindServiceIp}" --host="${bitcoindHostName}" --directory="${baseRpcDir}" --force
ls -Ral /mnt/lk


#sleep 100000

# Print command and start bitcoin node.
echo "Command: bitcoind $PARAMS"
exec bitcoind $PARAMS

#sleep 100000