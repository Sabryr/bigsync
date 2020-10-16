#!/bin/bash
#sabryr 2020-01-23

if [ "$#" -ge 2 ]
then
	FILE=$1
	DONE_FILE=$2
	if [ "$( echo $FILE | awk '{print substr($0,length($0)-5,length($0))}')" == "$(sha1sum $FILE | awk '{print substr($0,0,6)}')" ]
	then 
		echo "OK $FILE" >> $DONE_FILE 
		#echo "OK $FILE"
	else 
		echo -- "ERROR -- $FILE" >> $DONE_FILE
		#echo -- "ERROR -- $FILE";
	fi; 
else
	echo "Need two argumanta, which are the full path to file and the name of the log file "
fi


