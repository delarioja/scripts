#!/bin/bash
echo "Escribe el año en que naciste con cuatro cifras" #Solicitamos el año de nacimiento
read ano
if [[ ! $ano =~ [0-9]+ ]]; # Comprobamos que los parámetros que hemos introducido son número y si no lo son mostramos un error
then
 echo "Error no puedes incluir más que números"
elif [ ${#ano} -ne 4 ] #Si la longitud del número incluido no es cuatro mostramos error
then
 echo "Debes incluir un número de cuatro dígitos"
else
 let resto=$ano%12 #obtenemos el resto
 horoscopo=('El Mono' 'El Gallo' 'El Perro' 'El Cerdo' 'La Rata' 'El Buey' 'El Tigre' 'El Conejo' 'El Dragón' 'La Serpiente' 'El Caballo' 'La Cabra') #creamos un array con los signos chinos
 echo "Si naciste en $ano te corresponde ${horoscopo[$resto]} según el horóscopo chino"
