#!/bin/bash
#sabryr 2020-01-08
#ToDO try backup01 as proxy
#export PATH=/mnt/staff/sabry/scripts:$PATH
MYNAME=$1
SRC_DIR=$2
TAR_DIR=$3
DIR=$4
SCP_TARGET=$5
sync (){
	Cdir=$SRC_DIR"/"$DIR
	Tdir=$TAR_DIR"/"$DIR".tar"
 	echo  "$Cdir started by " $MYNAME
	tar cf $Tdir $Cdir --hard-dereference &> /dev/null
	checksum=$(sha1sum $Tdir | awk '{print substr($0,0,6)}')
 	mv $Tdir $Tdir-$checksum
 	#scp $Tdir-$checksum $SCP_TARGET
 	#if [ $? -eq "0" ] ;
 	#then
 	#	rm $Tdir-$checksum
 	#fi
	sleep 10
	echo "Done " $Cdir
	echo $Cdir >> $TAR_DIR"/done"
}

sync $SRC_DIR $TAR_DIR
