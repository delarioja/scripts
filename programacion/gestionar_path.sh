#!/bin/bash
OPTIND=1 #Importante reiniciar esta variable si se quiere usar el script varias veces en la misma terminal.
#Expresión regular para S s o nada.
exp1='^[Ss]?$'
#Expresion regular para evitar -d o -i
exp2='^[-][di]$'
#variable para almacenar el archivo temporal que almacenará las rutas del $PATH.
file=/tmp/gestiona_path.tmp
if [[ -e $file ]]; then
 rm $file
fi
#Si no se pasan variables muestra por pantalla el valor de $PATH.
if [[ -z $1 ]]; then
 echo -e "El PATH es:\n$PATH"
#Si no se pasan como opciones -i o -d entnces se añanden al PATH los argumentos pasados.
elif [[ $1 != $exp2 ]]; then
 for i in $@; do
   PATH=$PATH:$i
 done
 echo -e "El nuevo PATH es:\n$PATH"
fi
#Bucle WHILE para contemplar las opciones -d y -i
while getopts id OPCION; do
 case $OPCION in
   #Con -i borro la última entrada del PATH con ayuda del comando SED.
   i) PATH=$(echo $PATH | sed -e 's/:[A-Za-z/.]*$//g')
      echo -e "El último directorio del PATH ha sido eliminado\n$PATH"
   ;;
   #Con -d listo y pregunto que rutas se quieren o no mantener en PATH.
   d) echo $PATH | sed -e 's/:/\n/g' >> $file
      while IFS= read -r -u 3 line
      do
        read -p "$line forma parte del PATH. ¿Quiere mantenerlo [S/n] " ans
        if [[ $ans =~ $exp1 ]] && [[ -z $new ]]; then #Este IF es para que en PATH no se guarden : al empezar.
          new=$line #La varialble $new va almacenando las distintas rutas separadas por : para luego volcarlo a $PATH.
        elif [[ $ans =~ $exp1 ]]; then
          new=$new:$line
        fi
      done 3< $file
      PATH=$new
      echo -e "El nuevo PATH es:\n$PATH"
      rm $file
   ;;
 esac
done
