#!/bin/bash
if ! [ $(id -u) = 0 ]; then
    echo "Es necesario que ejecutes este script como root..."
    exit 1
fi
if (($# == 0)); then
    dd if=/dev/zero of=fichero_vacio bs=1024K count=1
    echo -e "Se ha creado el archivo \e[3mFichero_vacio\e[0m con un tamaño de \e[3m1024K\e[0m"
elif (($# == 1)); then
    dd if=/dev/zero of=$1 bs=1024K count=1
    echo -e "Se ha creado el archivo \e[3m$1\e[0m con un tamaño de \e[3m1024K\e[0m"
elif (($# == 2)); then
    dd if=/dev/zero of=$1 bs=$2 count=1
    echo -e "Se ha creado el archivo \e[3m$1\e[0m con un tamaño de \e[3m$2K\e[0m"
elif (($# > 2)); then
    echo "No puedes introducir más de dos parámetros"
fi
