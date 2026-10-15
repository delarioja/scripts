#!/bin/bash
agen=agenda.txt
menu (){
	echo "Dispone de las siguientes opciones para la manipulacion de su agenda:"
	echo "#################################################################"
	echo "#	[1] Añadir registros a su agenda.                         #"
	echo "#	[2] Buscar en su agenda por nombre, dirección o teléfono. #"
	echo "#	[3] Eliminar registro (por nombre).                       #"
	echo "#	[4] Visualizar toda la agenda.                            #"
	echo "#	[5] Ordenar su agenda alfabeticamente.                    #"
	echo "#	[6] Eliminar agenda.                                      #"
	echo "#	[7] Modificar registro.                                   #"
	echo "# [8] Salir.                                                #"
	echo "#################################################################"

	read -p "Escoja un numero:" opt

	case $opt in
		1) pedir_datos
			;;
		2)buscar
			;;
		3)eliminar_reg
			;;
		4)cat $agen
			echo -e "\n\n"
			menu
			;;
		5)sort $agen
			echo -e "\n\n"
			menu
			;;
		6)rm -i $agen
			echo -e "\n\n"
			menu
			;;
		7)buscar_reemp
			;;
		8)exit
			;;
	esac
}

pedir_datos () {

	read -p "Introducir nombre:" var

	until [ "$var" = "$fin" ]; do

		read -p "Introducir direccion:" var1

		read -p "Introducir teléfono:" var2

		echo $var:$var1:$var2 >> agenda.txt

		read -p "Introducir nombre o escribir '"FIN"' para finalizar:" var

		fin=$(echo $var| grep '^[Ff][Ii][Nn]$')

	done

	echo -e "\n\n"

	menu

}

eliminar_reg (){

	read -p "Ingrese un nombre de la agenda:" nom

	cont=$(echo $nom | grep -iv agenda.txt| wc -l)

	cat $agen| grep -iv  $nom > agenda2.txt

	rm $agen; mv agenda2.txt $agen

	echo "Has borrado $cont registros"

	echo -e "\n\n"

	menu

}

buscar (){

	read -p "Ingresa un nombre de la agenda:" nom

	grep -i $nom $agen

	echo -e "\n\n"

	menu

}

buscar_reemp (){

	read -p "Dato a buscar para reemplazar:" var1

	read -p "Dato de reemplazo:" var2

	sed -e "s/$var1/$var2/g" $agen > agenda2.txt

	cat agenda2.txt > $agen

	rm agenda2.txt

	echo -e "\n\n"

	menu

}

menu
