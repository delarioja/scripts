#!/bin/bash

#Script realizado por Emi Cester

#esta funcion comprueba si el archivo que hemos introducido existe ya (fmto ejemplo: panadero)

function comprueba {

        i=1  # ponemos el contador a 1

        while [ $i -le 10 ] && [ -f $fichero1 ]; do #mientras que el valor del contador sea <=10 y exista el fichero

               fichero1=$fichero${i} # le damos los values panaderoX a la variable fichero1.

                if [ $i -eq 10 ]; then # si el valor es panadero10 no hacemos nada y nos salimos del programa

                        echo "existe ya ficheros del 1...9 con ese nombre $fichero NO HACEMOS NADA BYE"

                        exit

                fi

                let i=$i+1

        done

}

# crear2.sh

fichero=$1 # fichero  es el valor original del fichero

fichero1=$1 # es el valor final del nombre del fichero

#evaluamos los casos en los que los  hemos introducido 2, 1 o ningún argumento

#caso 2

if [ "$#" -eq 2 ]; then # si introducimos los dos parámetros

        comprueba # comprueba si existe el fichero y si existe le cambia el nombre

        sudo dd if=/dev/zero of=$fichero1 bs=$2 count=1024

        echo "dos parametros valor $fichero1"

fi

#caso 1

if [ "$#" -eq 1 ]; then # introducimos un parametro que es el del nombre

        comprueba #compreuba si existe el fichero y si existe le cambia el nombre

        sudo dd if=/dev/zero of=$fichero1 bs=1024 count=1

        echo "un parametro valor $fichero1"

fi

# Caso 0

if [ "$#" -eq 0 ];then # no introducimos ninguno de los dos parametros

         fichero="fichero_vacio" # al ser una cadena vacio las variables fichero y fichero1 tendrán un valor fijo fichero_vacio

         fichero1="fichero_vacio"

         comprueba # comprueba si existe el fichero y si existe le cambia el nombre

        echo "sin parametros valor $fichero1"

         sudo dd if=/dev/zero of=$fichero1 bs=1024 count=1

fi
