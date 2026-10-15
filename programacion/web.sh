#!/bin/bash
clear
read -p "¿Para que usuario deseas crear la web? " usuario
usuexiste=`grep "$usuario:" /etc/passwd`

#Si no existe el usuario lo crea
if [ -z $usuexiste ]
then
	useradd -m -s /bin/bash $usuario
	echo -e "$usuario\n$usuario" | passwd $usuario
fi

#Obtiene las IPs del equipo. 
#Los dos primeros cut para obtener las IPs del equipo
#El tr cambia los intro por espacios
#El último cut para quitar la 127.0.0.1
ips=`ifconfig | grep "inet addr:*.*.*.* B" | cut -d : -f 2 | cut -d " " -f 1 | tr "\n" " "`

#Añade las ips al BIND
for ip in $ips
do
	echo -e "$usuario \t IN A $ip">>/etc/bind/ciclos.conf
done

#Crea la página web personalizada para ese usuario
mkdir /var/www/$usuario 2> /dev/null
echo '<html><body><h1> Bienvenido '$usuario' </h1></body></html>'>/var/www/$usuario/index.html

#Añade dicho usuario para usarlo en apache
htpasswd -mb /etc/apache2/usuapache $usuario $usuario

#Crea la web en apache
echo -e "\n" >> /etc/apache2/sites-available/web
echo '<VirtualHost *>' >> /etc/apache2/sites-available/web
echo "Servername $usuario.iescomercio.es" >> /etc/apache2/sites-available/web
echo "DocumentRoot /var/www/$usuario" >> /etc/apache2/sites-available/web
echo '<Directory /var/www/'$usuario'>' >> /etc/apache2/sites-available/web
echo "allow from all" >> /etc/apache2/sites-available/web
echo "AuthType Basic" >> /etc/apache2/sites-available/web
echo 'AuthName "Solo '$usuario'"' >> /etc/apache2/sites-available/web
echo "AuthUserFile /etc/apache2/usuapache" >> /etc/apache2/sites-available/web
echo "Require user $usuario" >> /etc/apache2/sites-available/web
echo '</Directory>' >> /etc/apache2/sites-available/web
echo '</VirtualHost>' >> /etc/apache2/sites-available/web

#Reinicia los servidores
service bind9 restart
service apache2 restart
echo "ENTRADAS WEB Y DNS CREADAS"
