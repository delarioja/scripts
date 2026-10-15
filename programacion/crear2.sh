#!/bin/bash

if [ $# -gt 2 ];then
        echo "No puedes pasar mas de dos parametros"
# si existe el fichero
elif [ -z "$1" -a -e "$1" ];then
    echo "El fichero $1 existe"
    cont=""
    while [ -e $1$cont ] && [ "$cont" != "10" ]; do
        cont=$((cont+1))
    done
    if [ "$cont" == "10" ]; then
        echo Salimos no hay nombre libre hasta el 9
        exit 1
    fi
fi
# si no da un tamaño para el archivo por defecto será 1.024 Kilobytes
if [ $# -eq 1 ];then
    sudo dd if=/dev/sda of=$1$cont bs=1024 count=1
    echo "Se ha creado $1 con tamaño de 1024K."
    # si no da un nombre para el fichero por decfecto será fichero_vacio
elif [ $# -eq 0 ];then
    sudo dd if=/dev/sda of=fichero_vacio bs=1024 count=1
    echo "Se ha creado fichero_vacio con tamaño de 1024K."
elif [ $# -eq 2 ];then
    sudo dd if=/dev/sda of=$1$cont bs=$2 count=1
    echo "Se ha creado $1 con tamaño de $2K."
fi
