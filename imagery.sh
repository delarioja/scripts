#!/bin/bash

function redimensionar_imagen() {
  local ANCHO=$(whiptail --title "Redimensionar imagen" --inputbox "Introduzca el ancho deseado:" 10 30 0 300 --output-fd 1)
  local ALTO=$(whiptail --title "Redimensionar imagen" --inputbox "Introduzca el alto deseado:" 10 30 0 200 --output-fd 1)
  convert $IMG -resize ${ANCHO}x${ALTO}! $IMG
}

function colocar_borde() {
  local COLOR=$(whiptail --title "Colocar borde" --menu "Seleccione un color:" 15 40 4 \
    "Rojo" "Imagen con borde rojo" \
    "Verde" "Imagen con borde verde" \
    "Azul" "Imagen con borde azul" \
    "Negro" "Imagen con borde negro" \
   3>&1 1>&2 2>&3)
  convert $IMG -bordercolor $COLOR -border 50x50 $IMG
}

function poner_texto() {
  local TEXTO=$(whiptail --title "Poner texto" --inputbox "Introduzca el texto deseado:" 10 30 0 --output-fd 1)
  convert $IMG -gravity South -annotate 0 '${TEXTO}' $IMG
}

function convertir_blanco_y_negro() {
  convert $IMG -colorspace Gray $IMG
}

function crear_gif_animado() {
  # Implementación pendiente
  echo "Crear gif animado..."
}

function crear_montaje() {
  # Implementación pendiente
  echo "Crear montaje..."
}

function reducir_imagen() {
  convert $IMG -resize 50% $IMG
}

IMG=$(whiptail --title="Seleccionar imagen" --imgview /path/to/default.png --output-fd 1)

OPCION=$(zenity --title="Menú Programa" --width "400" --height "300" --list --text "Bienvenido, elige una opción" --radiolist --column "Elige" --column "Opciones" \
TRUE "Redimensionar la imagen" FALSE "Colocar un borde de color" FALSE "Poner un texto" FALSE "Convertir en blanco y negro" FALSE "Crear un gif animado" FALSE "Crear un montaje con varias fotos" FALSE "Reducir una imagen")

case $OPCION in
  "Redimensionar la imagen")
    redimensionar_imagen
    ;;
  "Colocar un borde de color")
    colocar_borde
    ;;
  "Poner un texto")
    poner_texto
    ;;
  "Convertir en blanco y negro")
    convertir_blanco_y_negro
    ;;
  "Crear un gif animado")
    crear_gif_animado
    ;;
  "Crear un montaje con varias fotos")
    crear_montaje
    ;;
  "Reducir una imagen")
    reducir_imagen
    ;;
  *)
    echo "Opción no válida seleccionada"
    ;;
esac