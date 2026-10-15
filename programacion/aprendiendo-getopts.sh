#!/bin/bash
while getopts mt:r: MYOPTION
do
    case $MYOPTION in
    t) echo "El argumento para la opción -t es $OPTARG en posición " $(($OPTIND-1))
    ;;
    r) echo "El índice siguiente al argumento de -r es $OPTIND y el argumento es $OPTARG"
    ;;
    m) echo "El flag -m ha sido activado"
    ;;
    ?) echo "Lo siento, se ha intentado una opción no existente"; exit 1;
    ;;
    esac
done
#Podemos ahora probar el efecto de una invocación del guión como ésta:
#delarioja@delarioja-vm:~/scripts$ aprendiendo-getopts -m -r hola -t adios -l
#El flag -m ha sido activado
#El índice siguiente al argumento de -r es 4 y el argumento es hola
#El argumento para la opción -t es adios
#/home/delarioja/scripts/aprendiendo-getopts: illegal option -- l
#Lo siento, se ha intentado una opción no existente
