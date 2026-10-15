#!/bin/bash
#declaramos los contadores y arrays
d=0
e=0
t=0
dv=0
declare -a array_dir;
declare -a array_ejec;
declare -a array_txt;
declare -a array_dv;

#Guardamos los valores en arrays para luego mostrarlos
# los valores auxiliares tomarán el último valor del array
if [ $# -eq 1 ]; then
cd $1
fi

for i in $(ls); do
	if test -d $i ; then
		let d=$d+1
		aux_dir=$i
		array_dir[d]=$i', '
	elif test -x $i ;then
		let e=$e+1
		aux_ejec=$i
		array_ejec[e]=$i', '
	elif [[ $(file $i | grep -o special) == "special" ]]; then
		let dv=$dv+1
		aux_dv=$i
		array_dv[dv]=$i', '
	elif [[ $(file $i | grep -o text) = "text" ]]; then
		let t=$t+1
		aux_txt=$i
		array_txt[t]=$i', '
	fi

done
# trucamos el último valor del array quitandole la , (para eso nos hemos guardado un valor auxiliar )
array_dir[d]=$aux_dir
array_ejec[e]=$aux_ejec
array_txt[t]=$aux_txt
array_dv[dv]=$aux_dv

#presentamos los valores de los diferentes arrays
echo "La clasificacion de ficheros del directorio ${PWD##*/} es:"
echo "hay $d directorios:${array_dir[*]}"
echo "hay $e ficheros ejecutables: ${array_ejec[*]}"
echo "hay $t ficheros txt: ${array_txt[*]}"
echo "hay $dv ficheros dv: ${array_dv[*]}"
