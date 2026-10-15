#!/bin/bash 
# En esta primera línea introduzco en la variable hora, la hora actual en formato 24h
hora=$(date +%H)
# hago un ls para listar los ficheros del directorio cows y con el resultado elijo uno aleatorio
animal=$(ls /usr/share/cowsay/cows | shuf -n 1)
# en este condicional dependiendo de la hora del día, dará los buenos días, tardes o noches al usuario, aparte de que con el comando cowsay -f “$animal” sacamos un mensaje de texto dentro de un globo de dialogo acompañado del dibujo de algún animal compuesto de caracteres
    if [ $hora -ge 8 ] && [ $hora -lt 15 ]; then 
        cowsay -f "$animal" "Buenos días "
    elif [ $hora -ge 15 ] && [ $hora -lt 21 ]; then
        cowsay -f "$animal" "Buenas tardes "
    else
        cowsay -f "$animal" "Buenas noches "
    fi