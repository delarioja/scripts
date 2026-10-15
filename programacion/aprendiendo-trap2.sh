#!/bin/bash
# Puedes ir modificándolo para aprender a usar aprendiendotrap
# Comandos útiles: https://likegeeks.com/es/scripting-de-bash-en-linux-senales-y-trabajos/
# ps -l
# kill -l
LOCK=/tmp/aprendiendotrap2
trap "echo Borrando ando; rm -f $LOCK && echo Borrado" INT TERM EXIT
   touch $LOCK
   #rsync -avz /media/pincho $HOME/copia
   while [[ -e $LOCK ]]; do
   # si quieres un bucle infinito imparable con ctrl+c pero sí con kill -9
   # while [[ true ]]; do
     echo Hola mundo$var
     var=$(($RANDOM%13 +1))
     if [[ $var -eq 13 ]]; then
       echo LLegué al 13!
       rm $LOCK
     fi
     sleep 0.2
   done

trap - INT TERM EXIT
