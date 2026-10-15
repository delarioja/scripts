#!/bin/bash
#solución con 2 bucles
if [ "$#" -eq 2 ]; then
	for palabra in $(cat $1 ); do
		while read linea; do
			a=$(echo $linea | grep -oi $palabra|wc -w)
			if [ -n "$a" ]; then
				cont=$(($cont+$a))
			fi
		done < $2
		if [ "$cont" -ne 0 ]; then
		echo $palabra $cont	>> respuesta
		fi
		cont=0
	done
	cat respuesta | sort -n -r
	rm respuesta
else
	echo "No has ingresado los ficheros"
fi
