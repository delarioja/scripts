#!/bin/bash
echo "El nombre del programa es "$0
echo "El primer parámetro recibido es "$1
echo "El segundo parámetro recibido es "$2
echo "En total se han recibido "$#" parámetros"
echo "Esta es una cadena mía: "$@
echo "Valor de retorno última instrucción "$?
echo "Todos los parámetros concatenados \$*: " $*
echo "El PID de ejecución del programa es \$$ " $$
kill $$
echo FIN
