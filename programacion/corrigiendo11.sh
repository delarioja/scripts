#!/bin/bash

if [ "$#" -eq 2 ]; then
	for palabra in $(cat $1 ); do
		while read linea; do
			a=$(echo $linea | grep -o $palabra|wc -w)
			if [ -n "$a" ]; then
				cont=$(($cont+$a))
			fi
		done < $2
		if [ "$cont" -ne 0 ]; then
		echo $palabra $cont
		fi
		cont=0
	done
else
	echo "No has ingresado los archivos"
fi
