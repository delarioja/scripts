
#!/bin/bash
# Germán Prado Alonso
# Práctica UD4 - ASO
# 9. horoscopo.sh https://www.iteramos.com/pregunta/3193/como-puedo-comprobar-si-una-variable-es-un-numero-en-bash

# ----------------------------------------------------------------------------------------------------------------------------------------
# Preguntamos el año de nacimiento para almacenarlo en una variable
read -p "Introduce tu año de nacimiento, recuerda que tiene que tener cuatro cifras: " -a var

#comprobamos que se ha introducido algún dato, en caso contrario finalizamos  el script
if [ -n "$var" ]; then

	#comprobamos si el dato introducido es un número positivo de 4 cifras
	es_numero='^[0-9]{4}+?$'
	if ! [[ $var =~ $es_numero ]] ; then

		# como no es un positivo de cuatro cifras, configuramos el aviso del error en función del dato
		# comprobamos si es un número negativo
		if  [[ "$var" -lt "0" ]] ; then
			# es un número negativo, mostramos el aviso y finalizamos el script
			echo -e "\e[0;31mERROR\e[0m: El dato no puede ser un número negativo, por lo que no se puede continuar." && exit 1

		else
			# como no es negativo, se trata de un número positivo que no tiene 4 cifras o de un texto
			# comprobamos si es un número positivo
			if  [[ "$var" =~ ^[0-9]+$ ]] ; then
                		# se trata de un número que no  tiene las cuatro cifras, mostramos el aviso y finalizamos el script
                		echo -e "\e[0;31mERROR\e[0m: El año introducido no tiene cuatro dígitos, por lo que no se puede continuar."

			else
				# se trata de un texto, por lo que mostramos el aviso y finalizamos el script
				echo -e "\e[0;31mERROR\e[0m: El dato es un texto y no un número, por lo que no se puede continuar." && exit 1

			fi
		fi

	else

		# se trata de un número positivo de 4 cifras
                # cargamos los datos de la tabla del horóscopo chino en un array, cada posición corresponde al valor numérico de la tabla
                signo=("El Mono" "El Gallo" "El Perro" "El Cerdo" "La Rata" "El Buey" "El Tigre" "El Conejo"
                        "El Dragón" "La Serpiente" "El Caballo" "La Cabra")

                # Para obtener el resultado, calculamos el resto del año divido entre 12 y buscamos la posición que corresponde en el array
                echo "Si naciste en $var te correponde ${signo[$var%12]} según el horóscopo chino."

	fi

else
        # mostramos el aviso de que no se ha puesto ningún dato
    	echo -e "\e[0;31mERROR\e[0m: No se ha puesto ningún dato, por lo que no se puede continuar."
fi

# ----------------------------------------------------------------------------------------------------------------------------------------


