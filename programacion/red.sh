#!/bin/bash
clear
read -p "Introduce el nombre de la  tarjeta a configurar: " tarjeta
existe=`ifconfig -a | grep -o $tarjeta`
if test -z $existe 
then
        echo "LA TARJETA INDICADA NO EXISTE"
else
        read -p "Introduce la dir IP a asignar: " ip
        read -p "Introduce la máscara a asignar: " mascara
        ifconfig $tarjeta $ip netmask $mascara
        echo "TARJETA CONFIGURADA"
fi
