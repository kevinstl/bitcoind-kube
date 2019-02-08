#!/usr/bin/env bash


# Set the mining flag only if address is non empty.
if [ -z "${MINING_ADDRESS}" ] && [ "${MINING_ADDRESS}" != "empty" ]
then
    PARAMS="$PARAMS --miningaddr=$MINING_ADDRESS"
fi


