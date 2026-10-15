#!/bin/bash
# Práctica UD4 Programación Basch Scripts
# Administración de Sistemas Operativos
# 2º Administración de Sistemas Informáticos en Red
#
# Comprobamos si se han introducido parámetros, y si son correctos
if [ $# -eq 1 ]; then                       # Si introducimos un parámetro
  # Comprobamos que el parámetro introducido es un directorio, y si no lo es, imprime mensaje y sale del script
  test ! -d $1 && echo -e "\e[0;31mERROR\e[0m: \e[1;33m$1\e[0m no es un directorio" && exit 1
  cd $1                                     #   cambiamos al directorio introducido por parámetros
elif [ $# -gt 1 ]; then                     # Si introducimos más de un parámetro
  echo -e "\e[0;31mERROR\e[0m: Se permite \e[1;33mun solo directorio\e[0m como parámetro"
  exit 1
fi
#
declare -a array_txt                        # Declaramos el array para archivos de texto
declare -a array_dev                        #    para ficheros de dispositivo
declare -a array_dir                        #    para directorios
declare -a array_exe                        #    para ficheros ejecutables
#
for resultado in $(ls); do                  # Realiza un bucle para cada resultado obtenido de ls
  if [[ "$resultado" == *.txt ]]; then              # Si el resultado es un fichero de texto
   array_txt+=("$resultado")                        #    lo almacena en el array
  elif [[ -b $resultado || -c $resultado ]]; then   # Si el resultado es un fichero de dispositivo
   array_dev+=("$resultado")                        #    lo almacena en el array
  elif [[ -d $resultado ]]; then                    # Si el resultado es un directorio
   array_dir+=("$resultado")                        #    lo almacena en el array
  elif [[ -x $resultado ]]; then                    # Si el resultado es un fichero ejecutable
   array_exe+=("$resultado")                        #    lo almacena en el array
  fi
done
#
# Imprimimos los resultados en pantalla
echo -e "La clasificación de ficheros del directorio \e[0;34m$PWD\e[0m es:"
echo -e "·Hay ${#array_txt[@]} ficheros de texto: \e[35m${array_txt[*]}\e[0m"
echo -e "·Hay ${#array_dev[@]} ficheros de dispositivo: \e[35m${array_dev[*]}\e[0m"
echo -e "·Hay ${#array_dir[@]} directorios: \e[35m${array_dir[*]}\e[0m"
echo -e "·Hay ${#array_exe[@]} ficheros ejecutables: \e[35m${array_exe[*]}\e[0m"
