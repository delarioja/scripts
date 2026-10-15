#!/bin/bash 
echo "#" > aux.acls #Inicializa el fichero donde va a ir copiando las líneas del fstab
while read linea # lee el fstab línea a línea
do
	lineav=(`echo $linea`) # guarada la línea leida como un vector 
	uuid=`echo ${lineav[0]} | cut -c 4` # guarda los 4 primeros caracteres de la línea
        if [ "$uuid" == "UUID" ] # mira si los 4 primeros caracteres son UUID
	then
		disco=`echo ${lineav[1]} | cut -c 1` # guard el primer caracter del montaje
		if [ "$disco" == "/" ] # mira si el primer caracter es una /
		then
			lineav[3]="${lineav[3]},acl" # añade ,acl en las opciones
		fi
		echo ${lineav[*]} >> aux.acls # guarda toda la línea con la opción ,acl
	else
		echo $linea >> aux.acls
	fi	
done < /etc/fstab
mv aux.acls /etc/fstab
