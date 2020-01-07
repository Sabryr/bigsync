#!/bin/bash
#sabryr 2020-01-03
#export PATH=/mnt/staff/sabry/scripts:$PATH
LOCATION=$1 #"/mnt/cees/sabry/size/"
#results="results.log"
TARTARGET=$2  #"/mnt/cees/sabry/size/tmp/"
PROGRESS=$TARTARGET"progress.txt"
touch $PROGRESS
SCP_TARGET=""
DIR_NUM=$(ls -l $LOCATION | wc -l)
i=0;

for dir in $(ls $LOCATION)
do 
	rsyncwrap.sh $LOCATION$dir $TARTARGET$dir.tar $SCP_TARGET $PROGRESS 
done

#if [[ -f "$results"]]
#then
#export V="T";
#i=0; 
#for num in $(awk '{print $1}' results.log | grep $V | awk -F $V '{print $1}')
#do 
#	i=$(bc <<< "$i+$num")
#	done
#	echo $i"$V"
#	echo "found" 
#else 
#	echo "not found"
#fi

