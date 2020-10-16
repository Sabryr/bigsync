#!/bin/bash
#sabryr 2020-01-23
# "srun --account=nn9999k --nodes=1 --cpus-per-task=1 --mem-per-cpu=0 --time=3-00:05:10"
#./checksum-runner.sh /cluster/home/sabryr/jobs/filetransfer/tmp 2 "srun --account=nn9999k --nodes=1 --cpus-per-task=1 --mem-per-cpu=1G --time=00:05:10"
##./checksum-runner.sh /cluster/shared/staff/sabry/work/users/sabryr/cees/in_progress/ 2 "srun --account=nn9999k --partition=bigmem --nodes=1 --cpus-per-task=1 --mem-per-cpu=0 --time=5-00:05:10"


LOCATION=$1 


PROGRESS=$LOCATION"/checksum-progress.txt"
DONE=$LOCATION"/checksum-done"
touch $PROGRESS
touch $DONE

NUM_JOBS=5


SRUN_PREFIX="LOCAL"

if [ "$#" -ge 1 ]
then
	NUM_JOBS=$2
	if [ "$#" -ge 2 ]
	then
		SRUN_PREFIX=$3
	fi
fi


let DIR_NUM=$(ls -l $LOCATION/*tar* | wc -l)-1

i=0
skipped=0
gap_wait=0;
GAP_WAIT_MAX=600

getgap (){
	A=$(wc -l $PROGRESS | awk '{print $1}')
	B=$(wc -l $DONE | awk '{print $1}')
	let GAP=$A-$B
	return $GAP
}


for dir in $(ls -rt $LOCATION | grep tar)
do 
	getgap
	GAP=$?
	while [ $GAP  -gt $NUM_JOBS ] && [ $gap_wait -le $GAP_WAIT_MAX ]
	do
		getgap
		GAP=$?
		echo "waiting for "$GAP " attempts: "  $gap_wait 
		sleep 60
		let gap_wait=$gap_wait+1;
	done
	gap_wait=0
	if grep -q $LOCATION"/"$dir $PROGRESS
	then 
		echo "found --- "$LOCATION"/"$dir &> /dev/null
		let skipped=$skipped+1
 	else 
		echo "echo $LOCATION"/"$dir >> $PROGRESS "
		let i=$i+1
		if [ "$SRUN_PREFIX" == "LOCAL" ]
		then
			echo ./checksum-test.sh $LOCATION"/"$dir $DONE &
		else
			echo $SRUN_PREFIX ./checksum-test.sh  $LOCATION"/"$dir $DONE &
		fi
		sleep 1
	fi	
done
echo $skipped " of "$DIR_NUM" skipped " 

