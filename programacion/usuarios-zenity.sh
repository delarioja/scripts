#!/bin/bash

# Gestion de usuarios grafica
# Bajo licencia GPL

function main(){
while [ true ]
do
opcion=`zenity --list --height=245 --width=320 --radiolist 
          --title="Gestión de Usuarios y/o Grupos" 
         --column="" --column="Opción" 
           "FALSE" "1 Crear Usuario con Directorio Home" 
          "TRUE" "2 Crear Grupo" 
      "FALSE" "3 Añadir Usuario/Grupo" 
      "FALSE" "4 Eliminar Usuario/Grupo" 
           "FALSE" "5 Eliminar un Usuario" 
           "FALSE" "6 Mostrar Usuarios de un Grupo" 
          "FALSE" "7 Salir de la Aplicación"`
if [ "$?" == 1 ] ; then seleccion 7 ; fi 
seleccion `echo $opcion | cut -c 1` "$opcion" 
done
}

function seleccion(){
case $1 in
1)
user=`zenity --entry --width=300 --text "Nombre del usuario" --title "$2"`
cod=`echo $?`
if [ $cod == 0 ] 
then
sudo adduser $user
if [ "$?" == 1 ] 
then
zenity --warning --title="AddUser" --text="El usuario $user ya existe"
else
echo "creo el usuario $user" >> /tmp/log 
progress "Creando usuario" $user "$2"
fi
elif [ $cod == -1 ]
then
zenity --error --no-wrap --title="Error" --text="Ocurrió un error"
fi
;;
2)
group=`zenity --entry --width=300 --text "Nombre del grupo" --title "$2"` 
cod=`echo $?`
if [ $cod == 0 ] 
then
creargrupo "$group" 
if [ "$?" == 0 ] 
then
progress "Creando grupo" $group "$2"
echo "creo el grupo $group" >> /tmp/log
fi
elif [ $cod == -1 ] 
then
zenity --error --no-wrap --title="Error" --text="Ocurrio un error"
fi
;;
3)
listaUser=`cat /etc/passwd | cut -d: -f1 | sort` 
user=`zenity --list --height=300 --title="Elija un usuario" --column="USER" $listaUser` 
cod=`echo $?`
if [ $cod == 0 ] 
then
lsgrp=`cat /etc/group | cut -d: -f1 | sort`
grp=`zenity --list --height=300 --title="Elija un grupo" --column="GRUPOS" $lsgrp`
sudo usermod -aG $grp $user 
zenity --info --no-wrap --title="$2" --text="Se agregó '$user' al grupo $grp"
echo "Se agregó a $user al grupo $grp" >> /tmp/log
elif [ $cod == -1 ] 
then
zenity --error --no-wrap --title="Error" --text="Ocurrió un error"
fi
;;
4)
listaUser=`cat /etc/passwd | cut -d: -f1 | sort`
user=`zenity --list --height=300 --title="Elija un usuario" --column="USER" $listaUser`
cod=`echo $?`
if [ $cod == 0 ] 
then
lsgrp=`cat /etc/group | cut -d: -f1 | sort`
grp=`zenity --list --height=300 --title="Elija un grupo" --column="GRUPOS" $lsgrp`
sudo deluser $user $grp 
zenity --info --no-wrap --title="$2" --text="Se eliminó a '$user' del grupo $grp"
echo "Se eliminó a $user del grupo $grp" >> /tmp/log
elif [ $cod == -1 ] 
then
zenity --error --no-wrap --title="Error" --text="Ocurrió un error"
fi
;;
5)
listaUser=`cat /etc/passwd | cut -d: -f1 | sort`
user=`zenity --list --height=300 --title="Elija una opción" --column="USER" $listaUser`
cod=`echo $?`
if [ $cod == 0 ] 
then
zenity --question --title="deluser" --text="Borrar el directorio Home de $user?"
if [ $? == 0 ]
then
sudo deluser $user --remove-home
echo "Se eliminó el usuario $user y su directorio personal /home/$user" >> /tmp/log
progress "Eliminando Usuario" $user "$2"
else
sudo deluser $user
echo "Se eliminó el usuario $user pero se mantiene /home/$user" >> /tmp/log
progress "Eliminando Usuario" $user "$2"
fi
elif [ $cod == -1 ] 
then
zenity --error --no-wrap --title="Error" --text="Ocurrió un error"
fi
;;
6)
lsgrp=`cat /etc/group | cut -d: -f1 | sort`
grp=`zenity --list --height=300 --title="Elija un grupo" --column="GRUPOS" $lsgrp`
cod=`echo $?`
if [ $cod == 0 ] 
then
member=`cat /etc/group | grep $grp: | cut -d: -f4 | sort` 
zenity --info --no-wrap --title="$2" --text="El grupo $grp tiene como miembros: $member"

echo "Listando los miembros de $grp" >> /tmp/log
elif [ $cod == -1 ] 
then
zenity --error --no-wrap --title="Error" --text="Ocurrió un error"
fi
;;
7)
if [ -e /tmp/log ]
then

zenity --text-info 
                          --title="LOG" 
                          --filename=/tmp/log
                          --editable 2>/tmp/tmp.txt
           rm /tmp/log /tmp/tmp.txt

           fi
           exit
   ;;
esac
}

function progress(){
(
echo "0" ; sleep 1
        echo "# $1" ; sleep 1
        echo "25" ; sleep 1
        echo "75" ; sleep 1
        echo "100" ; sleep 1
        echo "# Finalizado"

        ) |
        zenity --progress 
          --title="$3" 
          --text="" 
          --percentage=0 
          --width=300

        if [ "$?" = -1 ] ; then
                zenity --error 
                  --text="Suma Abortada."
        fi
}

function creargrupo(){

gksudo groupadd $1
if [ "$?" == 9 ]
then
zenity --warning --title="Groupadd" --text="El grupo '$1' ya existe"
return 1
else
return 0
fi
}

main 
