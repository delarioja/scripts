#!/bin/bash
if [ $# -lt 1 ]; then
  echo "Tienes que introducir por lo menos un número como parámetro"
  exit 1
fi
mayor=$1
menor=$1
suma=$1
shift
# while [ ! -z $1 ]; do
#   if [ $mayor -lt $1 ]; then
#     mayor=$1
#   elif [ $menor -gt $1 ]; then
#     menor=$1
#   fi
#   suma=$(( $suma + $1 ))
#   shift
# done
for i in $@; do
  if [ $mayor -lt $i ]; then
    mayor=$i
  elif [ $menor -gt $i ]; then
    menor=$i
  fi
  suma=$(( $suma + $i ))
done
echo "El número mayor es $mayor"
echo "El número menor es $menor"
echo "La suma es $suma"
