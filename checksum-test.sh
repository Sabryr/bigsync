#!/bin/bash

for file in $(ls); do if [ "$( echo $file | awk '{print substr($0,length($0)-5,length($0))}')" == "$(sha1sum $file | awk '{print substr($0,0,6)}')" ]; then echo "OK"; else echo "Error";fi; done;
