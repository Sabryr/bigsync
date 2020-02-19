#!/bin/bash
#sabryr 2020-01-08
#ToDO try backup01 as proxy
#export PATH=/mnt/staff/sabry/scripts:$PATH
#./tarsync-runner.sh /projects/cees/in_progress /work/users/sabryr/cees sabryr@saga.sigma2.no:/cluster/shared/staff/sabry 5 "srun --account=staff --nodes=1 --cpus-per-task=16 --mem-per-cpu=0 --time=5-00:05:10"
#tarsync-runner.sh /mnt/staff/sabry/cees/files /mnt/staff/sabry/cees/transfer sabryr@saga.sigma2.no:/cluster/shared/staff/sabry/cees 5 "LOCAL" 
# To skip use grep syntext string as 6th argument "10.txt\|1.txt\|2.txt\|3.txt\|4.txt\|5.txt\|9.txt"

LOCATION=$1 #"/mnt/cees/sabry/size/"
TARTARGET=$2  #"/mnt/cees/sabry/size/tmp/"
LOCATION_DIR_NM=$(echo $LOCATION | awk -F "/" '{print $NF}')
TARTARGET=$TARTARGET"/"$LOCATION_DIR_NM
mkdir -p $TARTARGET

echo $TARTARGET

PROGRESS=$TARTARGET"/tar-progress.txt"
DONE=$TARTARGET"/tar-done"
touch $PROGRESS
touch $DONE
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

touch $PROGRESS
touch $DONE
echo $PROGRESS
echo $DONE
i=0
skipped=0
gap_wait=0;
GAP_WAIT_MAX=1440

getgap (){
	A=$(cat $PROGRESS | sort | uniq | wc -l| awk '{print $1}')
	B=$(cat $DONE | sort | uniq | wc -l| awk '{print $1}')
	let GAP=$A-$B
	#let GAP=5
	if [ $GAP -le 0 ]
	then	
		GAP=0
	fi
	return $GAP
}

AVOID="XX_XX_XX"
if [ "$#" -ge 6 ]
then
	AVOID=$6
fi

for dir in $(ls $LOCATION | grep -v $AVOID)
do 
	getgap
	GAP=$?
	while [ $GAP  -gt $NUM_JOBS ] && [ $gap_wait -le $GAP_WAIT_MAX ]
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
		echo "found --- "$LOCATION"/"$dir 
		#&> /dev/null
		let skipped=$skipped+1
 	else 
		echo $LOCATION"/"$dir >> $PROGRESS
		let i=$i+1
		if [ "$SRUN_PREFIX" == "LOCAL" ]
		then
			 tarsync.sh $i $LOCATION $TARTARGET $dir $SCP_TARGET $DONE &
		else
			 $SRUN_PREFIX tarsync.sh $i $LOCATION $TARTARGET $dir $SCP_TARGET $DONE &
		fi
		sleep 1
	fi	
done
echo $skipped " of "$DIR_NUM" skipped " 
