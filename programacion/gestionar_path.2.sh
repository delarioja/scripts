#!/bin/bash
# Carlos Ramírez
# USO
# gestionar_path.sh [-d] [-i] [-a directorio]
# -d Borrar el último directorio de PATH
# -i Listar los directorios almacenados en PATH y decidir cuales eliminar
# -a diretorio  Agregar un nuevo directorio a PATH
if [ $# -eq 0 ]; then
  echo $PATH
else
# Utilizo getops para realizar acciones en función del parámetro indicado
# Opciones -d, -i o -a
while getopts dia: arg
do
  case $arg in
    a)
	# Comprobar que -a esta acompañado de un directorio
      if [[ ! -d $OPTARG ]]; then
        echo -e "\e[1;31mNo ha especificado un directorio válido\e[0m"
        exit 1
      else
	# Si es un directorio se agrega a la variable PATH
        export PATH=$PATH:$OPTARG
      fi
      ;;
    d)
	# con -d se elimina el último directorio usando sed y
	# una expresión regular (desde los últimos : al final de línea)
      export PATH=$(echo $PATH | sed -e 's/:[A-Za-z/.]*$//g')
      ;;
    i)
	# Defino la variable directorio vacía
      directorio=""
	# Defino la variable número que tomará su valor del recuento (wc -l)
	# de los separadores : de los directorios de la variable PATH más 1
      numero=$((1 + $(echo $PATH | grep -o ':' | wc -l)))
	# Uso numero para determinar las veces que se ejecuta el bucle for
      for (( i = 1; i <= $numero ; i++ )); do
        echo "¿Quiere guardar el siguiente directorio en la variable PATH?"
	# Dentro de una variable temp pongo el resultado de cortar el
	# contenido de la varible PATH por el separador : y en el tramo
	# indicado por $i, asi listaré todos los directorios contenidos.
        temp=$(echo $PATH | cut -d ':' -f $i)
        echo $temp
	# pregunto al usuario si quiere conservar el directorio
        read -p "Introduzca d para eliminar o cualquier otra tecla para conservar " respuesta
	# si la respuesta es distinta a d entonces este directorio que está
	# almacenado en la variable temp se agrega a la variable directorio
	# y se añade el separador :
        if ! [[ $respuesta == "d" ]]; then
          directorio=$directorio$temp":"
        fi
      done
	# termina el bucle y elimino los últimos : generados en el bucle.
      cortar=$(echo $directorio | sed -e 's/:$//g')
	# Exporto la variable
      export PATH=$cortar
      ;;
    ?)
      echo "\e[1;31mNOpción indicada no existente\e[0m"
      ;;
  esac
done
# Se muestra el resultado final del contenido de PATH
echo "La variable path actual es:"
echo $PATH
# Pregunto al usuario si quiere hacer el cambio persistente
read -p "¿Quieres que el cambio en PATH sea persistente? [s/N] " sn
# En caso de s o S se buscan las líneas del archivo ~/.bashrc que empiecen
# por PATH= para eliminarlas con sed y se agrega al final del archivo la
# nueva variable generada utilizando echo y una redirección >>
if [[ "$sn" =~ [Ss] ]]; then
  sed -i '/^PATH=/d' ~/.bashrc
  echo "El cambio se ha realizado de forma persistente"
  echo "PATH=$PATH" >> ~/.bashrc
  echo "Ejecuta source ~/.bashrc"
fi
fi
