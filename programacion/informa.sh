#!/bin/bash
# FP a distancia.- Francisco Sánchez Suárez
# Práctica UD4 Programación Bash Scripts
# con funciones y uso de AWK

# Función para mostrar el parámetro -a SUELDO ANUAL
function mostrarSueldoAnual() {
   # Recoge el puesto asociado al DNI
   puesto=$(awk -F: '$4 == "'$DNI'" {print $6}' ./bdreparto)

   # Recoge la paga extra del puesto
   case $puesto in
      'Productor'|'Productora' ) extra=1500;;
      'Director'|'Directora' ) extra=900;;
      'Actor principal'|'Actriz principal' ) extra=854;;
      'Actor'|'Actriz' ) extra=700;;
      'Guionista' ) extra=500;;
   esac

   # Imprime la cabecera y la fila que corresponde al DNI introducido, calculando el sueldo anual y ordenando
   awk -F: 'BEGIN {print ":Nombre:Apellido:DNI:Sueldo Mensual:Sueldo Anual"} \
            $4 == "'$DNI'" {print ":"$2":"$3":"$4":"$5":"($5*12)+("'$extra'"*2)}' ./bdreparto | column -t -s ':' -n
}

# Función para mostrar el parámetro -m INFO EMPLEADO
function mostrarInfoEmpleado() {
   # Imprime la cabecera y la fila que corresponde al DNI introducido, ordenando los campos
   awk -F: 'BEGIN {print ":NºEmpleado:Nombre:Apellido:DNI:Puesto Trabajo:Sueldo Mensual (euros)"} \
            $4 == "'$DNI'" {print ":"$1":"$2":"$3":"$4":"$6":"$5}' ./bdreparto | column -t -s ':' -n
}

# Estructura de control principal
while getopts ':a:m:' OPCION; do
   case "$OPCION" in
      a ) DNI=${OPTARG} && mostrarSueldoAnual ;;
      m ) DNI=${OPTARG} && mostrarInfoEmpleado ;;
      *) echo "Error: -${OPTARG} requiere un argumento de tipo DNI." && exit 1
   esac
done
