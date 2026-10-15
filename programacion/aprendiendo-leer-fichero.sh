#!/bin/bash
for i in words; do
	#statements
done
short -r fichero.txt

linea=$(grep $1 $2|head -1)
i=1
campo=$(echo $linea |cut -d ":" -f$i)
while [[ -n $campo ]]; do
	echo $campo
	((i++))
	campo=$(echo $linea |cut -d ":" -f$i)
done
