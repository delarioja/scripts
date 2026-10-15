#!/bin/bash
ps -eo user,vsz --sort user > salida.txt
tail -n +2 salida.txt > fichero-procesos.txt
echo -e "USUARIO\tTOTALVSZ" > salida.txt
while read linea ; do
    usuario=$(echo $linea | cut -d" " -f1)
    #echo "trabajando: $usuario $mem_temp"
    grep -q $usuario salida.txt
    #si encontrada algo grep devuelve 0 = true
    # el -q es modo quiet sino habría que hacer: >/dev/null
    if [ $? -ne 0 ] ; then
       echo -e "$usuario\t"$(grep $usuario fichero-procesos.txt | awk '{ SUMA=SUMA+$2 }END{print SUMA}') >> salida.txt
    fi
done < fichero-procesos.txt
cat salida.txt
rm salida.txt fichero-procesos.txt
