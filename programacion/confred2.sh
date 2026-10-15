!/bin/bash
clear
echo "# Configuración realizada por confred2.sh" > auxred
#Guarda en un vector todas las tarjetas existentes
tarjetas=(`ifconfig -a | grep "eth" | cut -d " " -f 1`)
i=0 #variable que permite dirigirnos a las posiciones del vector

#Bucle para ir tarjeta a tarjeta (almacenadas en el vector tarjetas)
while [ ${tarjetas[$i]} ]
do
	#La opción -n 1 en read lee solo un caracter. Asi no es necesario pulsar Intro
        read -n 1 -p "¿Desea configurar ${tarjetas[$i]}? (S/N) " config
	echo -e "\n"
	if [ "$config" == "S" ] || [ "$config" == "s" ]
	then
		echo -e "\t 1.- DHCP"
		echo -e "\t 2.- Estática"
		echo ""
		read -n 1 -p "Indique como desea configurarla: " conf
		echo -e "\n"
		case $conf in
		1)
			echo "auto ${tarjetas[$i]}" >> auxred
			echo "iface ${tarjetas[$i]} inet dhcp" >> auxred	
		;;
		2)
			read -p "Introduce la dir. ip para ${tarjetas[$i]}: " ip
			read -p "Introduce la máscara para ${tarjetas[$i]}: " masc
			read -p "Dirección Ip de la puerta de enlace: " pe
			echo "# Configuración de la tarjeta ${tarjetas[$i]}" >> auxred
                        echo "auto ${tarjetas[$i]}" >> auxred
                        echo "iface ${tarjetas[$i]} inet static" >> auxred
			echo -e "\t address $ip" >> auxred
			echo -e "\t netmask $masc" >> auxred
			if [ $pe ]
			then
				echo -e "\t gateway $pe" >> auxred
			fi
                ;;
		*)
			echo "LA TARJETA ${tarjetas[$i]} NO SE CONFIGURARÁ"
		;;
		esac

	fi
        i=$(($i+1))
done

# Mueve la configuración realizada (fichero auxred) al /etc/network/interfaces
mv auxred /etc/network/interfaces

#Pasamos a configurar los servidores DNS

read -n 1 -p "¿Desea configurar los servidores DNS? (S/N): " dns
echo -e "\n"
if [ "$dns" == "S" ] || [ "$dns" == "s" ]
then
	read -p "IP del DNS1: " dns1
	read -p "IP del DNS2: " dns2
fi

#Inicializa /etc/resolv.conf
echo "# Configuración realizada por confred2.sh" > /etc/resolv.conf

if [ $dns1 ]
then
	echo "nameserver $dns1" >> /etc/resolv.conf
fi

if [ $dns2 ]
then
	echo "nemeserver $dns2" >> /etc/resolv.conf
fi 
