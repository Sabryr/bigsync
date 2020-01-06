#!/bin/bash
#Sabryr 2020-01-06

Cdir=$1
Tdir=$2

if grep -q $LOCATION "$PROGRESS"
then
       	echo "found" >/dev/null
else
       	let i=i+1
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
