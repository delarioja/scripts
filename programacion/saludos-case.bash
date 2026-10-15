#!/bin/bash
#ejecutamos el programa saludos de la siguiente manera:  ./saludos.sh Nombre (la variable $1 será tu nombre)
#echo -e  interpreta caracteres con \ (ejemplo \t que es el tabulador o \n que es el salto de linea)

HORA=`date +%H` # Meto en la variable hora el primer dígito de la hora actual del sistema
case $HORA in
06| 07 | 08 |09 |10 |11 |12) echo "Buenas dias";;
13| 14 |15 |16 |17 |18 |19) echo "Buenas tardes";;
20| 21 |22 |23 |00 |01 |02 |03 |04 |05) echo "Buenas noches";;
esac