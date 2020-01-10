#!/bin/bash
let num=0+$1
for ((i=0; i<=$num; i++))
do
	./tarsync.sh $i /mnt/staff/sabry/files /mnt/staff/sabry/target &
done
exit 0
