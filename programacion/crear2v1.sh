#!/bin/bash
#Por Cristina Caro
error=0 # Creamos variable error para condicionar que se haga todo correctamente (valor 0) o muestre error (valor 1)
if [ $# -eq 0 ]
then
 f=fichero_vacio
else
 f=$1
fi
if [ -f $f ]  # Si el archivo existe
then
 echo "El fichero $f ya está creado" # Mostramos que el archivo está creado
 fichero=$f # Llamamos fichero al primer parámetro pasado
 ultimocaracter=${fichero: -1} # Obtenemos el último caracter del parámetro que hemos pasado
 letra='^[a-zA-Z]*$' # Expresión regular caracteres alfabéticos
 if [[ $ultimocaracter =~ $letra ]] # Si el último caracter es una letra
 then
   ultimocaracter=1 # Asingamos a ultimocaracter un 1
   fichero=$fichero$ultimocaracter # Almacenamos en fichero el nombre del fichero añadiendo al final la variable último caracter (1)
 fi
  longitud=${#fichero}-1 # Calculamos la longitud del fichero pasado y le quitamos uno por el último dígito/caracter
 nombrearchivo=${fichero:0:longitud} # nombrearchivo almacenará el nombre del fichero desde inicio hasta longitud
  for (( i = $ultimocaracter; i < 10; i++ )); # Bucle desde 1 ($ultimocaracter) hasta 9, donde i va tomando los valores de 1 a 9
 do
   if [ -f $nombrearchivo$i ] # Si existe nombrearchivo con el número que tenga i en ese momento
   then
     if [ $i -eq 9 ] # Miramos si el valor i del archivo que existe es nueve
     then
       error=1 # Cambiamos el valor de error a 1 para que en el siguiente if muestre error
       archivo=$nombrearchivo$i # Almacenamos en la variable archivo el nombre de archivo que está creado y termina en 9 para mostrarlo en el error personalizado del final
     fi
   else
     archivo=$nombrearchivo$i # Si no existe el archivo con el número al final lo almacenamos en la variable archivo
     break # Salimos del bucle for
   fi
 done
else # Si el archivo introducido como parámetro no existe
 archivo=$f #almacenamos el nombre del archivo en la variable archivo
fi
if [ $error -eq 0 ] # Si error es igual a 0 generamos el archivo
then
 if [ $# -eq 1 -o $# -eq 0 ] # En caso de incluir un único parámetro (nombre)
 then
   dd if=/dev/zero of=$archivo bs=1024 count=1024
   echo "Ha sido creado el siguiente archivo con el tamaño solicitado"
   du -sh $archivo
 elif [ $# -eq 2 ] # En caso de incluir dos parámetros: nombre y tamaño
 then
   dd if=/dev/zero of=$archivo bs=1024 count=$2
   echo "Ha sido creado el siguiente archivo con el tamaño solicitado"
   du -sh $archivo
#  elif [ $# -eq 0 ] # En caso de no incluir ningún parámetro creamos "fichero_vacío"
#  then
#    dd if=/dev/zero of=fichero_vacio bs=1024 count=1024
#    echo "Ha sido creado el siguiente archivo con el tamaño solicitado"
#    du -sh fichero_vacio
 else
   echo "Debes incluir como mucho dos parámetros"
 fi
else # Si error es igual a 1 mostramos mensaje de error y no hacemos nada
 echo "No ha podido crearse el archivo ya existe hasta $archivo"
fi
