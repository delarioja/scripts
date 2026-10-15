#!/bin/bash
# Keep checking if the process is running. And keep a count.
# comprobar con este compando
# watch -n 1 'ps aux | grep -v grep | grep -e "apt"'
# como se acaba ejecutando apt dist-upgrade al final del script
user=$(whoami)
if [ "$user" != "root" ]; then
   # Si no es root sale sin ejecutar nada
   echo "No eres root... :'("
   exit
fi
echo "Hola sr. Root! :) Procedamos con la actualización..."
apt update
apt -y dist-upgrade 1>/dev/null 2>/dev/null &
{
        percentage="0"
        while (true)
        do
            proc=$(ps aux | grep -v grep | grep -e "dist-upgrade")
            if [[ "$proc" == "" ]] && [[ "$percentage" -eq "0" ]];
            then
                # Nothing to do as the process was not running when we
                # started the script.
                break;
            elif [[ "$proc" == "" ]] && [[ "$percentage" -gt "0" ]];
            then
                # The process has finished. It is no longer running.
                # So slowly count the percentage down to 100%.
                sleep 0.4
                echo 98
                sleep 0.4
                echo 99
                sleep 0.4
                echo 100
                sleep 0.4
                break;
            elif [[ "90" -eq "$percentage" ]]
            then
                # The process is running and taking really long.
                # Instead of running up to # 100% we instead reach 50% and
                # reset the percentage count back to 30%.
                # Now that we are back at 30% we can start counting again.
                # We will keep looping here forever until the running process stops.
                # "uff... me está costando más de lo esperado..."
                sleep 1
                percentage="80"
            fi
            sleep 0.1
            echo $percentage
            percentage=$(expr $percentage + 1)
        done
} | whiptail --title Ejemplo --gauge "Actualizando todavía..." 6 50 0
