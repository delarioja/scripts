#!/bin/bash 
#POR DEFECTO
for i in *
do
	if [ -f copia/$i ]
	then
		echo $i ya existe en copia
	elif [ -d $i ]
	then
		echo $i es un directorio
	else
		cp $i copia/$i
	fi
done