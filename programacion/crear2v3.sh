#!/bin/bash
# FP a distancia.- Francisco Sánchez Suárez
# Práctica UD4 Programación Bash Scripts
# Administración de Sistemas Operativos
# 2º Administración de Sistemas Informáticos en Red
#
function cambiarNombre() {      # Función para cambiar el nombre del fichero
 for (( i = 1; i < 10; i++ )); do
     nuevoNombreFichero="$nombreFichero$i"
     test ! -f "$nuevoNombreFichero" && nombreFichero="$nuevoNombreFichero" && return
 done
 error=yes
 echo "       y no pudo renombrarse"
}
#
function compruebaSiExiste() {  # Funcion que comprueba si existe el fichero
 if test -e $nombreFichero; then
   echo -e "\e[0;31mERROR\e[0m: El fichero \e[1;33m$nombreFichero\e[0m ya existe"
   cambiarNombre
 fi
}
#
function compruebaTamano() {    # Función que comprueba si el tamaño introducido es válido
 numeroValido=^[0-9]+$
 if ! [[ $tamanoFichero =~ $numeroValido ]] ; then
   echo -e "\e[0;31mERROR\e[0m: El parámetro de tamaño: \e[1;33m$tamanoFichero\e[0m KiB no es un número válido"
   error=yes
 fi
}
#
function compruebaErrores() {   # Función que comprueba si ha habido errores
 if [[ $error == yes ]]; then
   exit 1
 fi
}
#
function creaFichero() {        # Función que genera el fichero con los parámetros
 dd if=/dev/zero of=$nombreFichero bs=1024 count=$tamanoFichero > /dev/null 2>&1
 #let tamanoFichero=$tamanoFichero*1024
 echo -e "Creado \e[1;33m$nombreFichero\e[0m de \e[1;33m$tamanoFichero\e[0m KiB"
}
#
case $# in                      # Estructura de control que define el comportamiento de los parámetros
 0) nombreFichero="fichero_vacio"
   tamanoFichero=1   # multiplicar por KiB
   ;;
 1) nombreFichero="$1"
   tamanoFichero=1   # multiplicar por KiB
   ;;
 2) nombreFichero="$1"
   tamanoFichero=$2
   ;;
 *) echo -e "\e[0;31mERROR\e[0m: Se han introducido \e[1;33m$#\e[0m parámetros. Sólo acepta 2 como máximo"
   exit 1;
   ;;
esac
#
compruebaSiExiste
compruebaTamano
compruebaErrores
creaFichero
