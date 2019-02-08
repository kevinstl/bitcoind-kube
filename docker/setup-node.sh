#!/bin/bash

miningAddress=`echo $1 | base64`

export MINING_ADDRESS=${miningAddress}



