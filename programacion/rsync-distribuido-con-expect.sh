#!/bin/bash
function salir {
  echo "Seleccionaste cancelar. $1"
  exit 1
}
red=$(whiptail --title "RANGO DE RED" --inputbox "Indica la parte de red acabada en . por ejemplo: 192.168.1." 10 60 "192.168.1." 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus -eq 0 ]; then
    echo "Tu red es:" $red
else
    salir "RANGO DE RED"
fi

ipinicio=$(whiptail --title "PRIMER NÚMERO" --inputbox "Cual es el PRIMER NÚMERO DE HOST en tu red, ejemplo: 10" 10 60 "1" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Tu ip inicial es:" $ipinicio
else
    echo "Seleccionaste cancelar."
fi

ipfinal=$(whiptail --title "ÚLTIMO NÚMERO" --inputbox "Cual es el ÚLTIMO NÚMERO DE HOST en tu red, ejemplo: 50?" 10 60 "100" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Tu ip final es:" $ipfinal
else
    echo "Seleccionaste cancelar."
fi
nombre=$(whiptail --title "Nombre del fichero de texto" --inputbox "Nombre del fichero?" 10 60 "" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Nombre del documento es:" $nombre
else
    echo "Seleccionaste cancelar."
fi
directorio1=$(whiptail --title "DIRECTORIO ORIGEN" --inputbox "Cuál es el DIRECTORIO del servidor/origen a sincronizar?" 10 60 "/home/delarioja/" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Directorio del servidor:" $directorio1
else
    echo "Seleccionaste cancelar."
fi
directorio2=$(whiptail --title "DIRECTORIO DESTINO" --inputbox "Cuál es el DIRECTORIO del cliente/s destino a sincronizar?" 10 60 "$directorio1" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Directorio del cliente:" $directorio2
else
    echo "Seleccionaste cancelar."
fi
seq -f "$red%g" $ipinicio $ipfinal | cat >> $nombre.txt
while read i ; do
  echo "Procesando: $i"
  # Procesar $i (línea actual)
  rsync -rtvz delarioja@$i:$directorio1 $directorio2
  /usr/bin/expect <<'FINAL'
  spawn ssh $i
  expect "$ "
  expect "$ "
  send "exit\r"
  FINAL
done < $nombre.txt
rm $nombre.txt
