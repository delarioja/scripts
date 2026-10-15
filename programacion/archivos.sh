#!/bin/bash
clear
echo "1.- Borrar archivo"
echo "2.- Copiar archivo"
echo "3.- Mover archivo"
echo -e "\n"
read -p "Elige una opción: " opcion
echo -e "\n"
case $opcion in
	1) 
	read -p "Ruta completa y nombre del archivo: " archivo
	if [ -e $archivo ] 
	then 
		rm $archivo 
	else 
		echo "El archivo no existe"
		exit 
	fi
	echo "Archivo borrado"
	;;
	2)
	read -p "Ruta completa y nombre del archivo origen: " archivoo
        if [ ! -e $archivoo ]
	then
                echo "El archivo no existe"
                exit 
        fi
	read -p "Ruta completa y nombre del archivo destino: " archivod
	cp $archivoo $archivod
	echo "Archivo copiado"
	;;
	3)
	read -p "Ruta completa y nombre del archivo: " archivoo
        if [ ! -e $archivoo ]
	then
                echo "El archivo no existe"
                exit
        fi
	read -p "Ruta completa donde mover el archivo: " archivod
	mv $archivoo $archivod
	echo "Archivo movido"
	;;
	*)
	echo "LA OPCIÓN ELEGIDA NO ES VALIDA"
	;;
esac
