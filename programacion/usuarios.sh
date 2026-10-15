#!/bin/bash
read -p "Introduce el usuario a crear: " usu
read -p "Introduce el grupo a asignar: " grupo
usuarios=`grep "$usu:" /etc/passwd`
grupos=`grep "$grupo:" /etc/group`
if [ -z $usuarios ]
then
	if [ -z $grupos ]
	then
		echo "EL GRUPO $grupo NO EXISTE"
	else
		useradd -m -s /bin/bash -g $grupo $usu
	fi
else
	echo "EL USUARIO $usu YA EXISTE"
fi
