#!/bin/bash
azul='\e[1;34m'
fin='\e[0m'
#Creamos un directorio en el Home del usuario
#Para que se guarden los registros del juego.
if [[ ! -d $HOME/ADIVINA  ]]; then
  mkdir -p $HOME/ADIVINA
  touch $HOME/ADIVINA/fame.txt $HOME/ADIVINA/shame.txt
else
  if [[ ! -f $HOME/ADIVINA/fame.txt ]]; then
    touch $HOME/ADIVINA/fame.txt
  elif [[ ! -f $HOME/ADIVINA/shame.txt ]]; then
    touch $HOME/ADIVINA/shame.txt
  fi
fi

#Todo el juego ira en un bucle WHILE
while true; do
  clear
  echo -e "
  *--*--*--*--*--*--*--*--*--*--*
  |                             |
  |           ${azul}ADIVINA${fin}           |
  |                             |
  |  [1]...Jugar                |
  |  [2]...Hall of fame         |
  |  [3]...Hall of shame        |
  |  [X]...Resetear marcadores  |
  |  [Q]...Salir                |
  |                             |
  *--*--*--*--*--*--*--*--*--*--*

  "
  read -p "        ¿Qué desea hacer? " menu


  case $menu in
    1) clear
       echo -e "${azul}ADIVINA${fin}"
       read -p "   desea saber su nombre ... " name
       clear
       vidas=150 #Parametro modificable para ajustar la dificultad.
       echo -e "
     *--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
     |                                               |
             Bienvenid@ $name, durante siglos
           la humanidad ha soñado con conocer
          el número mágico que ${azul}ADIVINA${fin} esconde.
         ¿Será usted el afortunado en descubrirlo?
          Pista: Es mayor que 0 y menor que 100.
             Además cambia en cada nuevo juego.
          Cuidado ya que solo dispone de $vidas vidas.
                Pulse INTRO para continuar ...
     |                                               |
     *--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
       "
       read -p "" ANY
       clear
       mgn=$(shuf -i 1-100 -n1) #Nueva forma de tener un número aleatorio entre 1 y100.
       #mgn=$((1+$RANDOM%100))
       #echo $mgn CHEAT MODE
       #Bucle WHILE para ir quitando vidas mientras se adivina el número secreto.
       while [[ $vidas -gt 0 ]] && [[ $num -ne $mgn ]]; do
         read -p " $name dispone de $vidas vidas. Dígame un número..." num
         #Condicionales IF para ir dando pistas al jugador.
         if [[ $num -lt $mgn ]]; then
           echo -e "El número mágico de ${azul}ADIVINA${fin} es MAYOR."
           ((vidas--))
         elif [[ $num -gt $mgn ]]; then
           echo -e "El número mágico de ${azul}ADIVINA${fin} es MENOR."
           ((vidas--))
         fi
       done
       #Si se pierden las vidas ADIVINA mata al jugador y lo manda al archivo de la vergüenza.
       if [[ $vidas -eq 0 ]]; then
         echo -e "
           *--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
           |                                               |
           *   ${azul}ADIVINA${fin} ha perdido la paciencia y un rayo   *
           |       abrasador atraviesa su pecho...         |
           *        Pulse INTRO para continuar ...         *
           |                                               |
           *--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
         "
         read -p "" ANY
         clear
         echo -e "Lo siento $name, usaremos tus cenizas para el arenero del gato de ${azul}ADIVINA${fin}."
         echo $name >> $HOME/ADIVINA/shame.txt
         read -p "Pulse culaquier tecla para volver al menú principal." ANY
       else
         #Si el jugador gana a ADIVINA el juego recoge su nombre y sus vidas
         #en el archivo de la gloria. Solo si esta entre los 3 mejores / primeros.
         echo -e "
           *--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
           |                                               |
               Enhorabuena $name ha adivinado el número
                   mágico haciendo que ${azul}ADIVINA${fin} explote
                         en millones de pedazos.
                     Le quedaban $vidas vida(s) restantes.

                Pulse cualquier tecla para continuar ...

           |                                               |
           *--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
         "
         read -p "" ANY
         echo "$vidas:$name" >> $HOME/ADIVINA/fame.txt
         echo " : " >> $HOME/ADIVINA/fame.txt # Esto lo he añadido por que si solo hay 1 linea me daba errores.
         echo " : " >> $HOME/ADIVINA/fame.txt
         sort -nr $HOME/ADIVINA/fame.txt | head -3 > $HOME/ADIVINA/fame.tmp && rm $HOME/ADIVINA/fame.txt && mv $HOME/ADIVINA/fame.tmp $HOME/ADIVINA/fame.txt
       fi
    ;;
    2) clear
      #Condiciona IF para saber si el archivo fame.txt esta vacio o no.
       if [[ -s $HOME/ADIVINA/fame.txt ]]; then
           vidas1=$(sed -n 1p $HOME/ADIVINA/fame.txt | cut -d: -f1)
           vidas2=$(sed -n 2p $HOME/ADIVINA/fame.txt | cut -d: -f1)
           vidas3=$(sed -n 3p $HOME/ADIVINA/fame.txt | cut -d: -f1)
           pos1=$(sed -n 1p $HOME/ADIVINA/fame.txt | cut -d: -f2)
           pos2=$(sed -n 2p $HOME/ADIVINA/fame.txt | cut -d: -f2)
           pos3=$(sed -n 3p $HOME/ADIVINA/fame.txt | cut -d: -f2)
         echo -e "
           *--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
           |                                               |
           *          List of ${azul}ADIVINA's${fin} SAYERS             *

                   CHAMPION $pos1 con $vidas1 vidas restantes

                   2ND .. $pos2 con $vidas2 vidas restantes
                   3RD .. $pos3 con $vidas3 vidas restantes
           *                                               *
           |        Pulse INTRO para continuar ...         |
           *--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
         "
         read -p "" ANY
       else
         echo -e "
           *--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
           |                                               |
           *      Ningún valiente ha logrado descubir      *
           |     el número mágico secreto de ${azul}ADIVINA${fin}.      |
           *         Pulse INTRO para continuar ...        *
           |                                               |
           *--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
         "
         read -p "" ANY
       fi
    ;;
    3) clear
       #Condicional IF para saber si shame.txt esta vacio o no.
       if [[ -s $HOME/ADIVINA/shame.txt ]]; then
         echo "*--*--*--*--*--*--*--* RIP *--*--*--*--*--*--*--*"
         echo "|                                               |"
         for i in $(cat $HOME/ADIVINA/shame.txt); do
           echo "   $i                "
         done
         echo "|                                               |"
         read -p "|      Pulse INTRO  tecla para continuar ...    |
*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
         " ANY
       else
         echo -e "
           *--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
           |                                               |
           *      El arenero de ${azul}Mizifu${fin} está vacío,         *
           |                  por ahora...                 |
           *         Pulse INTRO para continuar ...        *
           |                                               |
           *--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
         "
         read -p "" ANY
       fi
    ;;
    X) clear
    #Borramos los registros.
    echo -e "
      *--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
      |                                               |
      *   Eliminando cualquier recuerdo de heroes     *
      |       y valientes caidos ante ${azul}ADIVINA${fin}         |
      *        Pulse INTRO para continuar ...         *
      |                                               |
      *--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
      "
      read -p "" ANY
      rm $HOME/ADIVINA/fame.txt $HOME/ADIVINA/shame.txt && touch $HOME/ADIVINA/fame.txt $HOME/ADIVINA/shame.txt
    ;;
    Q) clear
        echo "Gracias por jugar a ADIVINA"
        sleep 2
        clear
        break
    ;;
  esac
done
