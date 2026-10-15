#!/bin/bash
if [ $# -lt 1 ]; then
echo "Tienes que introducir por lo menos un número como parámetro"
exit 1
fi

for i in $@; do
  echo $i >> params.txt
  ((suma+=$i))
done
menor=$(sort params.txt | head -1)
mayor=$(sort params.txt | tail -1)
rm params.txt
echo "El número mayor es $mayor"
echo "El número menor es $menor"
echo "La suma es $suma"
