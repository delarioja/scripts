#!/bin/bash

#Declaración de varibles
file='.env'
exp0='[Ss]'
exp1='php54'
exp2='php74'
exp3='php8'
version=$(sed -n 8p "$file" | cut -d "=" -f2)
rojo='\e[0;31m'
verde='\e[0;32m'
fin='\e[0m'

#Mostrar version a utilizar por docker-compose de Php
echo -e "\nActualmente la version de Php es: ${rojo}$version${fin}\n"


read -p "¿Desea cambiar la configuración de su entorno? [s/N]: " ans0
echo ""

if [[ $ans0 =~ $exp0 ]]; then
  case $version in
    php54)
      echo -e "\nVersiones alternativas disponibles ${verde}php74${fin} / ${verde}php8${fin}\n"
      read -p "¿Qué versión de Php quiere usar? " ans2
      if [[ $ans2 =~ $exp2 ]] || [[ $ans2 =~ $exp3 ]]; then
        sed -i "8s/.*/VERSION_PHP=$ans2/" "$file"
        echo -e "\nLa configuración de su entorno ha sido modificada.\n"
        cambio=$(sed -n 8p "$file")
        echo -e "${verde}$cambio${fin}\n"
        read -p "¿Desea cambiar el entorno aplicando la nueva configuración? [s/N]: " ans3
      else
        echo "Version no disponible. No se aplican cambios a su entorno."
      fi
    ;;
    php74)
      echo -e "\nVersiones alternativas disponibles ${verde}php54${fin} / ${verde}php8${fin}\n"
      read -p "¿Qué versión de Php quiere usar? " ans2
      if [[ $ans2 =~ $exp1 ]] || [[ $ans2 =~ $exp3 ]]; then
        sed -i "8s/.*/VERSION_PHP=$ans2/" "$file"
        echo -e "\nLa configuración de su entorno ha sido modificada.\n"
        cambio=$(sed -n 8p "$file")
        echo -e "${verde}$cambio${fin}\n"
        read -p "¿Desea cambiar el entorno aplicando la nueva configuración? [s/N]: " ans3
      else
        echo "Version no disponible. No se aplican cambios a su entorno."
      fi
    ;;
    php8)
      echo -e "\nVersiones alternativas disponibles ${verde}php54${fin} / ${verde}php74${fin}\n"
      read -p "¿Qué versión de Php quiere usar? " ans2
      if [[ $ans2 =~ $exp1 ]] || [[ $ans2 =~ $exp2 ]]; then
        sed -i "8s/.*/VERSION_PHP=$ans2/" "$file"
        echo -e "\nLa configuración de su entorno ha sido modificada.\n"
        cambio=$(sed -n 8p "$file")
        echo -e "${verde}$cambio${fin}\n"
        read -p "¿Desea cambiar el entorno aplicando la nueva configuración? [s/N]: " ans3
      else
        echo "Version no disponible. No se aplican cambios a su entorno."
      fi
    ;;
  esac
  if [[ $ans3 =~ $exp0 ]]; then
    echo -e "\nCerrando el entorno...\n" && sleep 1
    docker-compose down
    sleep 1
    echo -e "\nDesplegando nuevo entono...\n" && sleep 1
    docker-compose up -d
    echo -e "\nEntorno listo para su uso.\n"
  else
    echo "Configuración modificada pero entorno no desplegado."
  fi
else
  echo -e "No se ha realizado ninguna modificación en su entorno.\n"
fi
