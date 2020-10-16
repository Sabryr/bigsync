#get a list of file
ssh sabryr@saga.sigma2.no "ls /cluster/shared/staff/sabry$PWD"

#Create a remote directory
ssh sabryr@saga.sigma2.no "mkdir -p /cluster/shared/staff/sabry$PWD"
#trasnfer
for file in $(ls *tar*) ; do scp $file sabryr@saga.sigma2.no:/cluster/shared/staff/sabry$PWD"/"; if [ "$?" -eq 0 ]; then rm $file; else echo $file" -- Failed"; fi ;done;

