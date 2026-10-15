#!/bin/bash

for i in $(ls)
do
	if [ -d $i ]
	then
		echo "$i/" $(file $i)
	else
		if [ -x $i ]
		then
			echo "$i*  $(file $i)"
		else
			echo "$i-  $(file $i)"
		fi
	fi

done
