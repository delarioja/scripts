# revisa los ficheros y directorios de un directorio
# e indica el nombre y el número de líneas que tiene cada fichero
# o sólo el nombre si se trata de un directorio

for i in `ls`
do
	if [ -f $i ] 
	then
		echo Nombre: $i
		echo Contenido: `cat $i | wc -l`
		sleep 1
	else
		echo $i es un directorio
	fi
done
