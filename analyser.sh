#!/bin/bash
#sabryr 2020-01-03
#To calculate the space usage of
#very large folders 

location="$1"
results="results.log"
progress="$2"
for dir in $(ls $location)
do 
	if grep -q $location"/"$dir "$progress"
	then 
		echo "found" 
	else 
		echo $location"/"$dir >> "$progress"
		du -hs $location"/"$dir  >> "$results"
		sleep 2
	fi	
 	#tar cf "$dir.tar" "/mnt/cees/in_progress/$dir"
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

