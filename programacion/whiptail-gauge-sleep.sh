#!/bin/bash
# Keep checking if the process is running. And keep a count.
zona1="delarioja.red"
nombreusuario="delarioja"
ip1="192.168.1.1"
echo "\$TTL    1d" >> ./db.$zona1 &
echo "\$ORIGIN    $zona1." >> ./db.$zona1 &
echo "@      IN      SOA      dns1.$zona1. $nombreusuario.$zona1. (" >> ./db.$zona1 &
echo "                   2022053001         ;"      >> ./db.$zona1 &
echo "                           2h         ;"      >> ./db.$zona1 &
echo "                           1h         ;"      >> ./db.$zona1 &
#ir modificando este sleep con 1 3 o 5 para ver cómo funciona
sleep 3 &
echo "                           2w         ;"      >> ./db.$zona1 &
echo "                           1d )       ;"      >> ./db.$zona1 &
echo ";"      >> ./db.$zona1 &
echo "@                 IN        NS      dns1.$zona1."      >> ./db.$zona1 &
echo "@                 IN        A       $ip1"      >> ./db.$zona1 &
echo "dns1              IN        A       $ip1"      >> ./db.$zona1 &
echo "servidor1         IN        CNAME   dns1"      >> ./db.$zona1 &
echo "www               IN        CNAME   dns1"      >> ./db.$zona1 &
echo "ftp               IN        CNAME   dns1"      >> ./db.$zona1 &
echo "ntp               IN        CNAME   dns1"      >> ./db.$zona1 &
echo "correo            IN        A       $ip1"      >> ./db.$zona1 &
{
        percentage="0"
        while (true)
        do
            proc=$(ps aux | grep -v grep | grep -e "sleep")
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
            elif [[ "51" -eq "$percentage" ]]
            then
                # The process is running and taking really long.
                # Instead of running up to # 100% we instead reach 50% and
                # reset the percentage count back to 30%.
                # Now that we are back at 30% we can start counting again.
                # We will keep looping here forever until the running process stops.
                # "uff... me está costando más de lo esperado..."
                percentage="30"
            fi
            sleep 0.1
            echo $percentage
            percentage=$(expr $percentage + 1)
        done
} | whiptail --title Ejemplo --gauge "comprobando que termina" 6 50 0
