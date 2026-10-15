#!/bin/bash
# Práctica ASO
# 5. cuenta_tipos.sh

# ------------------------------------------------------------------------------------------------
# COMPROBAMOS SI HAY ALGÚN DATO DE DIRECTORIO Y SI LO HAY, SI SÓLO HAY UNO O SI ES CORRECTO ------
# EN EL CASO DE NO PONER NINGÚN PARÁMETRO NO ENTRARÁ EN NINGUNA DE LAS OPCIONES DEL CONDICIONAL --

# Realizamos la comparación (-eq) para ver si los parámetros recibidos sea igual a 1
if [ $# -eq 1 ]; then

  	# Con test evaluamos si se cumple que es directorio (-d), si no es así indicamos el error y salimos del script
  	test ! -d $1 && echo -e "\e[0;31mERROR\e[0m: el dato introducido no es un directorio." && exit 1

	# Si es un directorio el dato, entramos en el
  	cd $1

# Comparamos con -gt, si el número de parámetros introducidos es mayor de 1
elif [ $# -gt 1 ]; then

	# Indicamos el error de que se han puesto más de un directorio com parámetro y salimos del script
	echo -e "\e[0;31mERROR\e[0m: Sólo se  permite introducir un directorio como parámetro." && exit 1
fi

# ------------------------------------------------------------------------------------------------
# DECLARAMOS LOS ARRAYS PARA ALMACENAR LOS TIPOS -------------------------------------------------

# Declaramos el array de archivos de texto
declare -a array_txt

# Declaramos el array de ficheros de dispositivo (dev)
declare -a array_dev

# Declaramos el array de directorios
declare -a array_dir

# Declaramos el array de ficheros ejecutables
declare -a array_exe

# ------------------------------------------------------------------------------------------------
# REALIZAMOS UN BUCLE FOR PARA OBTENER LOS RESULTADOS DE LOS TIPOS DE ARCHIVO---------------------

# Creamos la variable almacen, para guardar los resultados de la busqueda de ls en el bucle for
for almacen in $(ls); do

  # Comprobamos si el valor de almacen tiene la extensión txt de texto
  if [[ "$almacen" == *.txt ]]; then
    # si es así y es txt, lo guardamos al array de textos
    array_txt+=("$almacen")

  # Si no es un archivo de texto, comprobamos si es un fichero de dispositivo
  elif [[ -b $almacen || -c $almacen ]]; then
    # si es así y es un archivo de dispositivo, lo guardamos al array correspondiente
    array_dev+=("$almacen")

  # Si no es un archivo consultado antes, comprobamos si es un directorio
  elif [[ -d $almacen ]]; then
    # Si es así, lo guardamos en e array de directorio
    array_dir+=("$almacen")

  # Para finalizar, comprobamos si es un fichero ejecutable
  elif [[ -x $almacen ]]; then
    # En caso afirmativo, lo guardamos en el array de ejecutables
    array_exe+=("$almacen")
  fi
done

# ------------------------------------------------------------------------------------------------
# MOSTRAR LOS RESULTADOS EN PANTALLA  ------------------------------------------------------------


# Imprimimos el título poniendo el directorio que es en color azul
echo -e "La clasificación de ficheros del directorio \e[0;34m$PWD\e[0m es:"

# Imprimimos los resultados del array de texto, mostrando cuantas posiciones tiene en array
echo -e "·Hay ${#array_txt[@]} ficheros de texto: \e[34m${array_txt[*]}\e[0m"

# Imprimimos los resultados del array de ficheros de dispositivo, mostrando cuantas posiciones tiene en array
echo -e "·Hay ${#array_dev[@]} ficheros de dispositivo: \e[34m${array_dev[*]}\e[0m"

# Imprimimos los resultados del array de directorios, mostrando cuantas posiciones tiene en array
echo -e "·Hay ${#array_dir[@]} directorios: \e[34m${array_dir[*]}\e[0m"

# Imprimimos los resultados del array de ficheros ejecutables, mostrando cuantas posiciones tiene en array
echo -e "·Hay ${#array_exe[@]} ficheros ejecutables: \e[34m${array_exe[*]}\e[0m"

# LLegados a ente punto finalizamos el programa con un exit 0, de que no hay ningún error
exit 0

# ------------------------------------------------------------------------------------------------
