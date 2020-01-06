#!/bin/bash
#sabryr 2020-01-03

LOCATION=$1 #"/mnt/cees/sabry/size/"
results="results.log"
TARTARGET=$2  #"/mnt/cees/sabry/size/tmp/"
PROGRESS=$TARTARGET"progress.txt"
touch $PROGRESS
SCP_TARGET="sabryr@saga.sigma2.no:/cluster/shared/staff/sabry"
DIR_NUM=$(ls -l $LOCATION | wc -l)
i=0;
for dir in $(ls $LOCATION)
do 
	if grep -q $LOCATION$dir "$PROGRESS"
	then 
		echo "found" >/dev/null 
	else 
		let i=i+1
		Cdir=$LOCATION$dir
		Tdir=$TARTARGET$dir.tar
		echo $Cdir >> "$PROGRESS"

		tar cf $Tdir $Cdir --hard-dereference &> /dev/null
		checksum=$(sha1sum $Cdir | awk '{print substr($0,0,6)}')
		mv $Tdir $Tdir-$checksum
		echo "$i of $DIR_NUM started " $(du -hs $Tdir-$checksum)
		scp $Tdir-$checksum $SCP_TARGET
		if [ $? -eq "0" ] ;
                then
			rm $Tdir-$checksum
		fi
		sleep 1
		echo "$i of $DIR_NUM done"
	fi	
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

