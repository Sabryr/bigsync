#!/bin/bash
#sabryr 2020-01-08
#ToDO try backup01 as proxy
#export PATH=/mnt/staff/sabry/scripts:$PATH
LOCATION=$1 #"/mnt/cees/sabry/size/"
#results="results.log"
TARTARGET=$2  #"/mnt/cees/sabry/size/tmp/"
PROGRESS=$TARTARGET"progress.txt"
touch $PROGRESS
SCP_TARGET=""
let DIR_NUM=$(ls -l $LOCATION | wc -l)-1

location="$1"
results="results.log"
progress="$2"

sync (){
	Cdir=$1
	Tdir=$2
	tar cf $Tdir $Cdir --hard-dereference &> /dev/null
	checksum=$(sha1sum $Cdir | awk '{print substr($0,0,6)}')
 	mv $Tdir $Tdir-$checksum
 	echo "$i of $DIR_NUM started " $(du -hs $Tdir-$checksum)
 	echo scp $Tdir-$checksum $SCP_TARGET
 	if [ $? -eq "0" ] ;
 	then
 		echo rm $Tdir-$checksum
 	fi
 	sleep 1
}

PROGRESS=$TARTARGET"/progress"
touch $PROGRESS
i=0
skipped=0
for dir in $(ls $location)
do 
	if grep -q $location"/"$dir $PROGRESS
	then 
		echo "found" &> /dev/null
		let skipped=$skipped+1
 	else 
		let i=$i+1
		echo $location"/"$dir >> $PROGRESS 
		sync $location"/"$dir $TARTARGET"/"$dir".tar"
	 	echo "$i of $DIR_NUM done"
		sleep 2
	fi	
 	#tar cf "$dir.tar" "/mnt/cees/in_progress/$dir"
done

echo $skipped " of "$DIR_NUM" skipped"
