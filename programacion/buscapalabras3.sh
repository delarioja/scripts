#!/bin/bash
# FP a distancia.- Francisco Sánchez Suárez
# Práctica UD4 Programación Bash Scripts
# Administración de Sistemas Operativos
# 2º Administración de Sistemas Informáticos en Red
#
# Comprueba que se han intrododucido dos parámetros válidos
if [[ $# -ne "2" ]]; then
  echo -e "Es necesario indicar dos ficheros de texto por parámetros" && exit 1
fi
test ! -f ./$1 && echo -e "El fichero $1 no ha sido encontrado" && exit 1
test ! -f ./$2 && echo -e "El fichero $2 no ha sido encontrado" && exit 1
#
# Comprueba cada una de las palabras clave a encontrar
for linea in $(cat "$1")
do
  # Si la palabra no ha aparecido en búsquedas anteriores (mayúscula o minúscula)
  if [[ $(grep -i -c "$linea" <<< "$resultado") -eq 0 ]]; then
     # Guarda la palabra y el nº de veces que aparece
     resultado+=$(echo -n "$linea " && echo -e "$(grep -c -i "$linea" $2);")
  fi
done
# Imprime el resultado, elimina el (;) del final, sustituye los (;) por retornos de carro,
# y ordena por la segunda columna (nº apariciones)
echo -e "$resultado" | sed -e 's/.$//' | sed -e $'s/;/\\\n/g' | sort -k 2
