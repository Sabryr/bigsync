#!/bin/bash
#sabryr 2020-01-08
#ToDO try backup01 as proxy
#export PATH=/mnt/staff/sabry/scripts:$PATH
#tarsync.sh 1 /mnt/cees/x /mnt/staff/sabry/cees cdir "NULL" out.log
#tarsync.sh 1 /mnt/cees/x /mnt/staff/sabry/cees cdir "saga.xxx:/cl../.../" out.log

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
		then
			checksum=$(sha1sum $Tdir | awk '{print substr($0,0,6)}')
			if [ $? -eq "0" ] ;
				then
				mv $Tdir $Tdir-$checksum
				echo "$Cdir -- OK ">> $DONE 
				if [[ $1 != NULL* ]]
				then
					#Do a tar list before this step
					scp $Tdir-$checksum $SCP_TARGET
				fi
			else
				echo "--ERROR2-- $Cdir -- Checksum calculation failed ">> $DONE 		
			fi
			
		else
			echo "--ERROR-- $Cdir -- Failed ">> $DONE 		
		fi
	}
	sync $SRC_DIR $TAR_DIR
else
	echo "Need 6 arguments"
fi
