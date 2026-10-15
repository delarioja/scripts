#!/bin/bash
#solución con 1 bucle
#comprobar que los ficheros existen
#if ! [ -f $1 ] || ! [ -f $2 ]; then
if [ ! -f "$1" -o ! -f "$2" ]; then
      exit 1
fi
touch contar.txt
#recorrer el primer fichero línea por línea que es lo mismo que palabra por palabra
while read linea; do

     contar=$(grep -iw $linea $2 | wc -l)
     # o también: contar=$(grep -iwc $linea $2)
     # la -c cuenta, la -w asegura que es una palabra completa con espacios a los lados
     # la -o muestra una salida con una línea por cada ocurrencia encontrada
     yaprocesada=$(grep -iw $linea contar.txt | wc -l)
     if [ $contar -ne 0 ] && [ $yaprocesada -eq 0 ]; then
          echo $linea $contar >>contar.txt
     fi

done < $1

sort -k2 contar.txt; rm contar.txt
