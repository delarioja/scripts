#! /bin/bash
read -p "INTRODUCE LA CARPETA O ARCHIVO: " carpeta
if ! test -e $carpeta
then
	echo "La carpeta no existe. Hasta Pronto"
	exit
fi

read -p "INTRODUCE EL USUARIO: " usuario
usuext=`grep "$usuario:" /etc/passwd`
if test -z $usuext   
then
	echo "Este usuario no existe. Hasta Pronto"
	exit
fi

read -p "INTRODUCE LOS PERMISOS (rwx): " permisos
setfacl -m u:$usuario:$permisos $carpeta
echo "ACL ASIGNADA"
