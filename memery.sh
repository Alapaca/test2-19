#!/bin/bash 

starttime=$(date +%Y_%m_%d__%H:%M:%S)
mem=`free -m | sed -n '2p' | awk '{print ""$3"M "$2"M "$3/$2*100"%"}'`
rate=`free -m | sed -n '2p' | awk '{print ""$3/$2*100""}'`
dancerate=`echo "scale=1;0.3*"${1}"+0.7*"${rate}""|bc`
echo $starttime $mem ${dancerate}%
