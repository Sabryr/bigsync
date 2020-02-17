#!/bin/bash
#sabryr 2020-01-08
#ToDO try backup01 as proxy
#export PATH=/mnt/staff/sabry/scripts:$PATH
#tarsync.sh 1 /mnt/cees/x /mnt/staff/sabry/cees cdir null out.log

if [ "$#" -ge 6 ]
then
	MYNAME=$1
	SRC_DIR=$2
	TAR_DIR=$3
	DIR=$4
	SCP_TARGET=$5
	DONE=$6
	touch $DONE
	sync (){
		Cdir=$SRC_DIR"/"$DIR
		Tdir=$TAR_DIR"/"$DIR".tar"
 		echo  "$Cdir started by " $MYNAME
		tar cf $Tdir $Cdir --hard-dereference &> /dev/null
		if [ $? -eq "0" ] ;
			checksum=$(sha1sum $Tdir | awk '{print substr($0,0,6)}')
			mv $Tdir $Tdir-$checksum
			echo "$Cdir -- OK ">> $DONE 
		else
			echo "--ERROR-- $Cdir -- Failed ">> $DONE 		
		fi
	}
	sync $SRC_DIR $TAR_DIR
else
	echo "Need 6 arguments"
fi

  		#scp $Tdir-$checksum $SCP_TARGET
	 	#if [ $? -eq "0" ] ;
 		#then
	 	#	rm $Tdir-$checksum
 		#fi
		sleep 10
		echo "Done " $Cdir
		echo $Cdir >> $DONE

