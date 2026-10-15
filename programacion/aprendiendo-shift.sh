#!/bin/bash
echo El nombre del programa es $0
echo El número total de parámetros es $#
echo Todos los parámetros recibidos son $*
echo Todos los parámetros recibidos son $@
echo El echo anterior ha terminado ok? no-news-good-news: $?
rm /
if (( $? ))
then
	echo control error $?
fi
echo El primer parámetro recibido es $1
shift
echo El segundo parámetro recibido es $1
shift
echo El tercer parámetro recibido es $1
