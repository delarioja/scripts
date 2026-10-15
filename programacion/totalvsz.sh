#!/bin/bash
ps -eo user,vsz --sort user > salida.txt
tail -n +2 salida.txt > fichero-procesos.txt
echo -e "USUARIO\tTOTALVSZ" > salida.txt
while read linea ; do
    usuario=$(echo $linea | cut -d" " -f1)
    mem_temp=$(echo $linea | cut -d" " -f2)
    #echo "trabajando: $usuario $mem_temp"
    grep -q $usuario salida.txt
    #si encontrada algo grep devuelve 0 = true
    # el -q es modo quiet sino habría que hacer: >/dev/null
    if [ $? -eq 0 ] ; then
    #if echo "$mem_temp" | grep -x -q "[0-9]\+" ; then
        mem_anterior=`grep $usuario salida.txt|cut -d" " -f2`
        #((mem_temp += $mem_anterior))
        mem_temp=$(( mem_temp + mem_anterior ))
#echo "sustituyendo: $usuario: $mem_anterior por $mem_temp"
#aunque la sustitución debería ser en base al nombre de usuario que es unívoco ya que
#en base a un número podría darse el caso de que coincidiera con otra entrada
        sed "s/$mem_anterior/$mem_temp/g" salida.txt > salida-tmp.txt
        cat salida-tmp.txt > salida.txt
    else
        #echo "grabando: $usuario $mem_temp"
        echo "$usuario $mem_temp" >> salida.txt
    fi
    #fi
done < fichero-procesos.txt
cat salida.txt
rm salida.txt salida-tmp.txt fichero-procesos.txt
