#!/bin/bash
#sabryr 2020-01-08
#ToDO try backup01 as proxy
#export PATH=/mnt/staff/sabry/scripts:$PATH

LOCATION=$1 #"/mnt/cees/sabry/size/"
TARTARGET=$2  #"/mnt/cees/sabry/size/tmp/"
PROGRESS=$TARTARGET"progress.txt"
touch $PROGRESS
SCP_TARGET=$3 #"sabryr@saga.sigma2.no:/cluster/shared/staff/sabry"
NUM_JOBS=5
SRUN_PREFIX="LOCAL"
if [ "$#" -ge 4 ]
then
	NUM_JOBS=$4
	if [ "$#" -ge 5 ]
	then
		SRUN_PREFIX=$5
	fi
fi


let DIR_NUM=$(ls -l $LOCATION | wc -l)-1

PROGRESS=$TARTARGET"/progress"
DONE=$TARTARGET"/done"
touch $PROGRESS
touch $DONE
i=0
skipped=0
gap_wait=0;
GAP_WAIT_MAX=1440

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
	while [ $GAP  -gt 5 ] && [ $gap_wait -le $GAP_WAIT_MAX ]
	do
		getgap
		GAP=$?
		echo "waiting "$GAP "  "  $gap_wait 
		sleep 10
		let gap_wait=$gap_wait+1;
	done
	gap_wait=0
	if grep -q $LOCATION"/"$dir $PROGRESS
	then 
		echo "found" &> /dev/null
		let skipped=$skipped+1
 	else 
		echo $LOCATION"/"$dir >> $PROGRESS 
		let i=$i+1
		if [ "$SRUN_PREFIX" == "LOCAL" ]
		then
			  ./tarsync.sh $i $LOCATION $TARTARGET $dir $SCP_TARGET &
		else
			  $SRUN_PREFIX ./tarsync.sh $i $LOCATION $TARTARGET $dir $SCP_TARGET &
		fi
		sleep 1
	fi	
done
echo $skipped " of "$DIR_NUM" skipped " 
