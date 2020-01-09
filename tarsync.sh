#!/bin/bash
#sabryr 2020-01-08
#ToDO try backup01 as proxy
#export PATH=/mnt/staff/sabry/scripts:$PATH
MYNAME=$1
LOCATION=$2 #"/mnt/cees/sabry/size/"
TARTARGET=$3  #"/mnt/cees/sabry/size/tmp/"
PROGRESS=$TARTARGET"progress.txt"
touch $PROGRESS
SCP_TARGET="$4"
echo $4
exit 1
let DIR_NUM=$(ls -l $LOCATION | wc -l)-1

sync (){
	Cdir=$1
	Tdir=$2
	tar cf $Tdir $Cdir --hard-dereference &> /dev/null
	checksum=$(sha1sum $Cdir | awk '{print substr($0,0,6)}')
 	mv $Tdir $Tdir-$checksum
 	echo "$i of $DIR_NUM started " $(du -hs $Tdir-$checksum) " by " $MYNAME
 	scp $Tdir-$checksum $SCP_TARGET
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
for dir in $(ls $LOCATION)
do 
	if grep -q $LOCATION"/"$dir $PROGRESS
	then 
		echo "found" &> /dev/null
		let skipped=$skipped+1
 	else 
		echo $LOCATION"/"$dir >> $PROGRESS 
		sync $LOCATION"/"$dir $TARTARGET"/"$dir".tar"
		let i=$i+1
		echo "$i of $dir done by "$MYNAME
		sleep 2
	fi	
 	#tar cf "$dir.tar" "/mnt/cees/in_progress/$dir"
done

echo $skipped " of "$DIR_NUM" skipped " 
