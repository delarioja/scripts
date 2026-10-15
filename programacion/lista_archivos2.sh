#/bin/bash
# Script para listar archivos
# Javier García Jiménez, 19/03/21
# Script basado en el de Emilia Cester, con la salida a color y verificando que sólo se pasa 1 ruta

# Compruebo si se pasa una ruta al ejecutar el script
if [ $# -eq 1 ]; then            # Si se pasa 1 ruta
  cd $1                          # hace un cd a esa ruta
elif [ $# -gt 1 ]; then          # Si se intenta pasar más de 1 ruta, da aviso de error
  echo "Por favor, pase como máximo 1 ruta";
  exit 1                         # Y sale del programa con código de error 1
fi                               # Cierro el if
# Ahora va un bucle que recorre todo el contenido del directorio tanto si se ha pasado algún parámetro
# como si no, en cuyo caso lo hará sobre el directorio desde el que se ejecute
for i in $(ls); do               # En cada elemento al hacer un ls
  if [ -d $i ]; then             # Si es un directorio
    echo -e '\e[0;31m'$i'/\e[0m' # le indico que lo pinte en rojo y ponga al final una barra /
  elif [ -x $i ]; then           # Si se trata de un ejecutable
    echo -e '\e[0;35m'$i'*\e[0m' # le indico que lo pinte en púrpura y ponga al final un arterisco *
  else                           # En cualquier otro caso (archivos)
    echo -e '\e[1;37m'$i'-\e[0m' # le indico que lo pinte en blanco y ponga al final un guión -
  fi                             # Cierro el if
done                             # Cierro el bucle
