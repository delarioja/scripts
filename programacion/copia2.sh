#!bin/bash

echo -e "\e[32m ¡Bienvenido al archivo de copias de archivos! \e[0m"
if [ $# -gt 2 ] || [ $# -eq 0 ]; then
    echo "Debes tener entre uno o dos parametros"
    exit 1
fi
#Ajustes de variables
###############################################################################################################
if [ -z "$2" ]; then
    cp -i $1 "$HOME"/copia/ > /dev/null 2>&1
else
    cp -i $1 $2 > /dev/null 2>&1
fi
#Mensajes de Exito
################################################################################################################
if [ "$var" != "" ]; then
    echo -e "\e[32m ¡¡¡¡¡COPIA RELIZADA CON EXITO EN EL FICHERO $var !!!!!\e[0m"
fi
if [ "$2" != "" ]; then
    echo -e "\e[32m ¡¡¡¡¡COPIA RELIZADA CON EXITO EN EL FICHERO $2 !!!!!\e[0m"
fi
if [ "$var" = "" ] && [ "$2" = "" ]; then
    echo -e "\e[32m ¡¡¡¡¡COPIA RELIZADA CON EXITO EN EL DIRECTORIO DE [copias] DENTRO DE [/home/$USERNAME]"
fi
################################################################################################################
