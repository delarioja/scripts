#!/bin/bash

#coger una linea de un fichero
linea=$(grep $1 $2|head -1)
#coger el primer campo de la linea
i=1
campo=$(echo $linea |cut -d ":" -f$i)

while [[ -n $campo ]]; do
	echo $campo
	((i++))
	campo=$(echo $linea |cut -d ":" -f$i)
done

#for (( i = 1; -n $campo; i++ )); do
	#statements
#done