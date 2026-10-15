#!/bin/bash
# Shell Script para aprender directivas de Apache donde se irán añadiendo paso a paso para que de tiempo a probarlas desde el navegador
# versión 4: Creación estructura, activación configuración, comprobaciones con chromium-browser
# Fernando Barcina - Nov-2021
# Instanciar la variable de abajo con la IP de la máquina donde se va a ejecutar
# Probado en UBUNTU 20.04
# Activa los módulos userdir auth_digest y rewrite y haz pruebas con los mismos
IP_SERVIDOR=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
function crearUsuario {
	username=$(whiptail --inputbox "¿Qué nombre de usuario va a tener?" 8 78 --title "Creando usuario: username" 3>&1 1>&2 2>&3)
	# read -s -p "Enter password : " password
	password=$(whiptail --passwordbox "¿Qué contraseña?" 8 78 --title "Creando usuario: password" 3>&1 1>&2 2>&3) # A trick to swap stdout and stderr.
	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "El usuario $username ya existe!"
		exit 1
	else
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
		useradd -m -p $pass -s /bin/bash $username
		[ $? -eq 0 ] && echo "Usuario añadido al sistema!" || echo "Problemas en el useradd! error de salida $?"
	fi
}
user=$(whoami)
if [ "$user" != "root" ]; then
   # Si no es root sale sin ejecutar nada
   echo "No eres root... :'("
   exit
fi
# INSTALACIÓN
if (whiptail --title "Hola sr. $user! :)" --yes-button "Adelante!" --no-button "No, ya está instalado" --yesno "¿Procedemos con la instalación de LAMP?" 8 78) then
    apt update
	apt install tasksel tree
	tasksel install lamp-server
fi
ping -c3 www.delarioja.red
ping -c3 intranet.delarioja.red
if (whiptail --title "Modificamos el fichero hosts? $IP_SERVIDOR www.delarioja.red" --yes-button "Aceptar" --no-button "Cancelar" --yesno "¿Modifico /etc/hosts?" 8 78) then
	CADENA=$(whiptail --title "Línea a añadir a /etc/hosts" --inputbox "Qué línea añado a /etc/hosts?" 10 60 "192.168.1.100 www.delarioja.red" 3>&1 1>&2 2>&3)
	echo $CADENA >> /etc/hosts
fi

#COMANDOS CREACIÓN ESTRUCTURA WEB
#Configuración por defecto UserDir cuando a2enmod userdir
echo "Creando estructura web de public_html de usuario delarioja"; sleep 1
mkdir -p /home/delarioja/public_html/acceso
cat <<'EOF' > /home/delarioja/public_html/probando-userdir-con-php.php
<html>
	<head>
			<title>Página del usuario DELARIOJA</title>
			<meta name="description" content="DELARIOJA WEB de www.delarioja.red">
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	</head>
	<body>
		<h1>Página Acceso a Web personal del usuario delarioja</h1></br><h2>Probando módulo UserDir en conjunción con AllowOverride que con grep -ri AllowOverride /etc/apache2 se ve que está configurado de una manera personalizada para este módulo. A continuación comprobamos si se ejecuta php:</h2>
		<?php
		phpinfo();
		?>
		</br><h2>Si no se ve nada de php encima de esto es que no se ejecuta, cierra el navegador y verás...</h2>
	</body>
</html>
EOF
# o también echo -e "<?php \n phpinfo(); \n ?>" >>/home/delarioja/public_html/index.php

#ZONA PRIVADA DIGEST
cat <<'EOF' > /home/delarioja/public_html/acceso/index.php
<html>
	<head>
			<title>Zona privada del usuario DELARIOJA</title>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	</head>
	<body>
		<h1>ACCESO SOLO PARA USUARIOS Matrix, verdaderos amigos del usuario delarioja</h1></br>
		<h2>Probando módulo AUTH_DIGEST en carpeta /home/delarioja/public_html/privada/index.php</h2></br>
		<h3>El usuario delarioja no debería poder entrar al pertenecer a otro grupo apache, ya entra como usuario linux a esta carpeta...</h3>
	</body>
</html>
EOF
read -p "Generando fichero de claves .htpasswd2 para acceso digest a carpetas protegidas por contraseña (pulsa Enter para Continuar)"
htdigest -c /home/delarioja/.htpasswd2 Matrix neo
htdigest /home/delarioja/.htpasswd2 Matrix trinity
htdigest /home/delarioja/.htpasswd2 Linux delarioja

read -p "Habilito módulos userdir auth_digest y rewrite (Pulsa Enter)"
a2enmod userdir auth_digest rewrite
echo "Ejecutando systemctl restart apache2"; sleep 1
systemctl restart apache2

read -p "Generando .htaccess en carpeta public_html del usuario delarioja, para listar si no hay directoryindex y en sitio www.conf para reescribirse a https sin wwww sin dar aviso de que no es navegable por http. Si compruebas el fichero userdir.conf se ve que permite por defecto AllowOverride->.htaccess (Pulse Enter para Continuar)"
tee /home/delarioja/public_html/.htaccess <<'EOF'
	#permitimos listar si no encuentra DirectoryIndex pero que no liste fotos:	Options +Indexes ya esta en modulo userdir.conf por defecto no poner aqui dado que AllowOverride no lo permite
	<FilesMatch "\.(gif|jpe?g|png)$">
		Require all denied
	</FilesMatch>
EOF
mkdir /var/www/www.delarioja.red/
tee /var/www/www.delarioja.red/.htaccess <<'EOF'

	RewriteEngine On
	# Añadido para quitar WWW de la URL, ten en cuenta que tienes que poner delarioja.red como ServerName en el VirtualHost de www.delarioja.red para que responda también y no cargue el predeterminado
	RewriteCond %{HTTP_HOST} ^www.delarioja.red [NC]
	#RewriteRule ^(.*)$ http://delarioja.red/$1 [L,R=301]
	RewriteRule ^(.*)$ http://delarioja.red/$1 [R=301,NC]

	# Forzar HTTPS podría probarse hasta con intranet.delarioja.red suponiendo que hayas activado HTTPS ahí también
	RewriteCond %{HTTPS} !=on
	RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
EOF
read -p "Generando .htaccess en carpeta public_html/privada del usuario delarioja, para usuarios apache válidos (Pulse Enter para Continuar)"
tee /home/delarioja/public_html/acceso/.htaccess <<'EOF'
	# carpeta con seguridad porque así lo quiere usuario delarioja, comparte con sus amigos de Matrix
	AuthType Digest
	AuthName "Matrix"
	AuthUserFile "/home/delarioja/.htpasswd2"
	Require valid-user
EOF
carpeta=/home/delarioja/public_html
touch $carpeta/foto.jpg $carpeta/foto.jpeg $carpeta/foto.gif $carpeta/foto.png
chown -R delarioja:www-data /home/delarioja/public_html/
chmod 755 /home/delarioja/public_html/
while (whiptail --title "¿Deseas crear más usuarios Linux para probar módulo Userdir?" --yes-button "Sí" --no-button "No" --yesno "¿Crear más usuarios Linux?" 8 78)
do
	crearUsuario
	cp -R /home/delarioja/public_html/ /home/$username/
	chown -R delarioja:www-data /home/$username/public_html/
	chmod 755 /home/$username/public_html/
done
# LLEGA EL MOMENTO DE LAS COMPROBACIONES
#módulos activos
apache2ctl -l
read -p "Vemos arriba los módulos activos de Apache (pulsa Enter para Continuar)"

    # que se vean links ocultos usuarios y grupos en tree
    tree -laug /home/delarioja/public_html
    read -p "Ahora ejecuta la parte de comprobaciones en el cliente y comprueba que navegando en http://www.delarioja.red debería reescribirse a https sin dar aviso, y solo usuarios neo y trinity pueden acceder a la carpeta 'acceso'. Desde Cliente ---> chromium-browser  http://www.delarioja.red/ http://www.delarioja.red/~delarioja http://intranet.delarioja.red:8080/~delarioja Este todavía no funciona: https://www.delarioja.red/~delarioja/probando-userdir-con-php.php dado que php está desactivado por defecto para UserDir (pulsa Enter para Activarlo)"

    # Comentamos la desactivación de php para userdir
    sed -i 's/php_admin_flag engine Off/#php_admin_flag engine Off/g' /etc/apache2/mods-available/php7.4.conf
    # Ahora sí debería dejar php a usuarios
    read -p "Prueba php en carpeta public_html y auth_digest en carpeta acceso: https://www.delarioja.red/~delarioja/probando-userdir-con-php.php https://www.delarioja.red/~delarioja/acceso/ (pulsa Enter para Continuar)"
    echo "Ejecutando systemctl reload apache2 para permitir php al directorio definido en userdir"; sleep 1
    systemctl reload apache2
