#!/bin/bash
clear
#Muestra las tarjetas existentes para permitir elegir una
tarjetas=(`ifconfig -a | grep "eth" | cut -d " " -f 1`)
i=0
while [ ${tarjetas[$i]} ]
do
	echo -e "\t $i.- ${tarjetas[$i]}"
	i=$(($i+1))
done
echo -e "\t $i.- SALIR"
read -p "¿Que tarjeta desea configurar?: " tconf

if [ $tconf -eq $i ]
then
	exit
fi

#Inicializa el fichero auxiliar
echo '#' > confred

#Busca la línea donde empieza la configuración de la tarjeta seleccionada
linauto1=`grep -n "auto ${tarjetas[$tconf]}" /etc/network/interfaces | cut -d ":" -f 1`

if [ $linauto1 ] #Si la tarjeta ya está configurada
then
	i=1
	linauto2=0

	#Busca la línea donde empieza la configuración de la siguiente tarjeta
	while read linea
	do
		lineav=(`echo $linea`)
		if [ "${lineav[0]}" == "auto" ] && [ $i -gt $linauto1 ]
		then
			linauto2=$i
			break
		else
			i=$(($i+1))
			linauto2=$i
		fi
	done < /etc/network/interfaces

	#Graba en el fichero auxiliar todas las líneas excepto las de la configuración 
	#de la tarjeta seleccionada (entre linauto1 y linauto2)
	i=1
	while read linea
	do
		if [ $i -lt $linauto1 ] || [ $i -ge $linauto2 ]
		then
			echo $linea >> confred
		fi
		i=$(($i+1))
	done < /etc/network/interfaces
fi

read -p "Introduce la dirección IP a asignar: " ip
read -p "Introduce la máscara a asignar: " mascara

if [ $linauto1 ] #Si la tarjeta ya estaba configurada
then
	echo "#" >> confred
	echo "auto ${tarjetas[$tconf]}" >> confred
        echo "iface ${tarjetas[$tconf]} inet static" >> confred
        echo -e "\t address $ip" >> confred
        echo -e "\t netmask $mascara" >> confred
	mv confred /etc/network/interfaces
else #Si la tarjeta no estaba configurada de antemano
	echo "#" >> /etc/network/interfaces
	echo "auto ${tarjetas[$tconf]}" >> /etc/network/interfaces
	echo "iface ${tarjetas[$tconf]} inet static" >> /etc/network/interfaces
	echo -e "\t address $ip" >> /etc/network/interfaces
	echo -e "\t netmask $mascara" >> /etc/network/interfaces
fi
