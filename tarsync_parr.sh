#!/bin/bash
#sabryr 2020-01-08
#ToDO try backup01 as proxy
#export PATH=/mnt/staff/sabry/scripts:$PATH

LOCATION=$1 #"/mnt/cees/sabry/size/"
TARTARGET=$2  #"/mnt/cees/sabry/size/tmp/"
PROGRESS=$TARTARGET"progress.txt"
touch $PROGRESS
SCP_TARGET=$3 #"sabryr@saga.sigma2.no:/cluster/shared/staff/sabry"

let DIR_NUM=$(ls -l $LOCATION | wc -l)-1

PROGRESS=$TARTARGET"/progress"
DONE=$TARTARGET"/done"
touch $PROGRESS
touch $DONE
i=0
skipped=0

getgap (){
	A=$(wc -l $PROGRESS | awk '{print $1}')
	B=$(wc -l $DONE | awk '{print $1}')
	let GAP=$A-$B
	return $GAP
}

for dir in $(ls $LOCATION)
do 
	getgap
	GAP=$?
	while [ $GAP  -gt 5 ]
	do
		getgap
		GAP=$?
		echo "waiting "$GAP
		sleep 2
	done
	if grep -q $LOCATION"/"$dir $PROGRESS
	then 
		echo "found" &> /dev/null
		let skipped=$skipped+1
 	else 
		echo $LOCATION"/"$dir >> $PROGRESS 
		let i=$i+1
		./tarsync.sh $i $LOCATION $TARTARGET $dir $SCP_TARGET &
		sleep 1

	fi	
done

echo $skipped " of "$DIR_NUM" skipped " 
