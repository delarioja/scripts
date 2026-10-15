#!/bin/bash
# Shell Script para aprender directivas de Apache donde se irán añadiendo paso a paso para que de tiempo a probarlas desde el navegador
# versión 4: Creación estructura, activación configuración, comprobaciones con chromium-browser --no-sandbox
# Fernando Barcina - Nov-2018
# Instanciar la variable de abajo con la IP de la máquina donde se va a ejecutar
# Probado en UBUNTU 18.04
#IP_SERVIDOR=ifconfig | awk '/inet addr/{print substr($2,6)}'
#IP_SERVIDOR=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
IP_SERVIDOR=$(hostname --all-ip-addresses|tr -d '[[space]]')
read -e -p "Por favor introduce la IP de la máquina donde servirá Apache la intranet [$IP_SERVIDOR]:" -i "$IP_SERVIDOR" IP_SERVIDOR
user=$(whoami)
if [ "$user" != "root" ]; then
   # Si no es root sale sin ejecutar nada
   echo "No eres root... :'(" 
   exit
fi
# INSTALACIÓN
echo "Hola sr. $user! :) Procedamos con la instalación de LAMP..."
apt update
apt install tasksel tree
tasksel install lamp-server
echo "Escribiendo en el fichero hosts: intranet.delarioja.red y www.delarioja.red"; sleep 1
echo $IP_SERVIDOR intranet.delarioja.red www.delarioja.red >> /etc/hosts
#COMANDOS CREACIÓN ESTRUCTURA WEB
#Sitio intranet navegable con intranet.delarioja.red
echo "Creando estructura de intranet"; sleep 1
 mkdir -p /var/www/intranet.delarioja.red/privada
 mkdir /var/log/apache2/intranet.delarioja.red
 mkdir /home/delarioja/wiki
 cat > /var/www/intranet.delarioja.red.delarioja.red/privada/index.html << 'EOF'
	<html> \
		<head> \
			<title>PÁGINA BANEADA EN /var/www/intranet.delarioja.red/privada/index.html</title> \
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/> \
			<meta name="description" content="Baneada de privada de intranet"> \
			</head> \
		<body><h1>Página Privada con IP baneada</h1></br> <h2>Probando directiva Require para prohibir a IP 192.168.1.1 lo que indica que tú no tienes 192.168.1.1 porque sino verías FORBIDDEN</h2> </body> </html>
EOF
echo "<html> \
		<head> \
			<title>PRIMEROS PASOS CON WIKI /home/delarioja/wiki/wiki.html</title> \
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/> \
			<meta name="description" content="Wiki Portal de intranet"> \
			</head> \
		<body><h1>Página Alias Wiki</h1></br> <h2>Probando directiva Alias para acceder a wiki en /home/delarioja/wiki metiendo url intranet.delarioja.red/wiki</h2> </body> </html>" > /home/delarioja/wiki/wiki.html
 chown -R www-data:www-data /home/delarioja/wiki /var/www/intranet.delarioja.red/
read -p "Comprueba qué tal va el script (Pulse Enter para Continuar)"
#Sitio delarioja.red navegable con www.delarioja.red
echo "Creando estructura de web www.delarioja.red"; sleep 1
 mkdir -p /var/www/www.delarioja.red/administrator
 mkdir /var/log/apache2/www.delarioja.red
 mkdir -p /home/delarioja/blog
 ln -s /home/delarioja/blog /var/www/www.delarioja.red/
# Cuando naveguemos www.delarioja.red/blog seguira el acceso directo que acabamos de crear
 echo "<html> \
		<head> \
			<title>PRIMEROS PASOS CON BLOG</title> \
			<meta name="description" content="BLOG de www.delarioja.red"> \
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/> \
			</head> \
		<body><h1>Página Acceso Blog</h1></br> <h2>Probando directiva Options FollowSymlinks que requiere un acceso directo para llegar a /home/delarioja/blog/index.html</h2></body> </html>" > /home/delarioja/blog/index.html
 
 chown -R www-data:www-data /home/delarioja/blog /var/www/www.delarioja.red/
 
	# Cuando error 404 en www.delarioja.red
 echo "<html> 
		<head> 
			<title>PAGINA PARA ERRORES 404</title>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/> 
			<meta name="description" content="Pagina no encontrada">
			</head>
		<body><h1>Página NO ENCONTRADA</h1></br> 
		<h2>Probando directiva ErrorDocument estás navegando una URL inexistente y por defecto se te muestra esto /var/www/www.delarioja.red/no-encontrada.htm</h2> 
		</body> 
		</html>" > /var/www/www.delarioja.red/no-encontrada.htm
    # Cuando naveguemos www.delarioja.red/administrator
 cat << 'EOF' > /var/www/www.delarioja.red/administrator/index.html
	<html> 
		<head> 
			<title>Página de administración o BACKEND</title> 
			<meta name="description" content="BACKEND de www.delarioja.red"> 
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/> 
			</head> 
		<body><h1>BACKEND de www.delarioja.red</h1></br> <h2>Probando autenticación basic pero con capa de seguridad SSL si se pone https delante de la URL</h2> </body> </html>
EOF
		
#Configuración por defecto UserDir cuando a2enmod userdir
echo "Creando estructura de public_html de usuario delarioja"; sleep 1
mkdir /home/delarioja/public_html/
cat <<'EOF' > /home/delarioja/public_html/index.php
<html> 
		<head> 
			<title>Página de administración o BACKEND</title> 
			<meta name="description" content="BACKEND de www.delarioja.red"> 
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/> 
			</head> 
	<body><h1>Página Acceso a Web personal del usuario delarioja</h1></br><h2>Probando módulo UserDir en conjunción con AllowOverride que con grep -ri AllowOverride /etc/apache2 se ve que está configurado de una manera personalizada para este módulo. A continuación comprobamos si se ejecuta php:</h2>
    <?php 
    phpinfo();
    ?> </br><h2>Si no se ve nada de php encima de esto es que no se ejecuta, cierra el navegador y verás...</h2></body> </html>
EOF
# o también echo -e "<?php \n phpinfo(); \n ?>" >>/home/delarioja/public_html/index.php
 cd /home/delarioja/public_html/ ;  touch foto.jpg foto.jpeg foto.gif foto.png; cd
 chown -R delarioja:www-data /home/delarioja/public_html/
 chmod 755 /home/delarioja/public_html/

	#ZONAS PRIVADAS
read -p "Generando fichero de claves .htpasswd para acceso basic a carpetas inseguras protegidas por contraseña (pulsa Enter para Continuar)"
 mkdir /var/www/passwd
 echo "Generando /var/www/passwd/.htpasswd, introduce contraseña de neo"
 htpasswd -c /var/www/passwd/.htpasswd neo
 htpasswd /var/www/passwd/.htpasswd trinity
 htpasswd /var/www/passwd/.htpasswd delarioja
# por si queremos probar también grupos
 cat > /var/www/passwd/.htgroup <<EOF
	Matrix: neo trinity
EOF
 htpasswd -c /home/delarioja/.htpasswd neo
 htpasswd /home/delarioja/.htpasswd trinity
 htpasswd /home/delarioja/.htpasswd delarioja
 read -p "Generando clave y certificado autofirmado para el SSL de web.conf"
 mkdir /etc/apache2/ssl
 cd /etc/apache2/ssl
 openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout clave-delarioja.pem -out certi-delarioja.pem

	# Generamos fichero /etc/apache2/sites-available/intranet.conf
	(
	 cat <<EOF
	<VirtualHost $IP_SERVIDOR:8080>
		ServerName intranet.delarioja.red
		DocumentRoot /var/www/intranet.delarioja.red
		DirectoryIndex inicio.htm pagina.html pag.html pag.htm pagina.htm
		ErrorDocument 404 "Página no encontrada"
		ErrorLog /var/log/apache2/intranet.delarioja.red/error.log
		CustomLog /var/log/apache2/intranet.delarioja.red/access.log combined
		Alias /wiki/ "/home/delarioja/wiki/"
		<Directory "/home/delarioja/wiki">
			   Options -Indexes
			   AllowOverride All
			   Require all granted
		</Directory>
		<Directory "/var/www/intranet.delarioja.red/privada">
				Options Indexes
				<RequireAll>
				Require all granted
				# Baneamos esta IP para que todos menos ella tengan acceso
				Require not ip 192.168.1.1
				</RequireAll>
		</Directory>
	</VirtualHost>
EOF
) > /etc/apache2/sites-available/intranet.conf

	# Generando fichero /etc/apache2/sites-available/web.conf
	 cat > /etc/apache2/sites-available/web.conf <<'EOF'
	<VirtualHost *:80 *:443>
		ServerName www.delarioja.red
		DocumentRoot /var/www/www.delarioja.red
		ErrorDocument 404 /no-encontrada.htm
		ErrorLog ${APACHE_LOG_DIR}/delarioja.red/error.log
		CustomLog ${APACHE_LOG_DIR}/delarioja.red/access.log combined
		<Directory "/var/www/www.delarioja.red/blog">
			   Options -Indexes +FollowSymLinks
			   AllowOverride None
			   Require all granted
		</Directory>
		#Documentación oficial de lo siguiente https://httpd.apache.org/docs/2.4/es/howto/auth.html
		<Directory "/var/www/www.delarioja.red/administrator">
			   #Si quisiéramos las directivas subsiguientes a nivel de .htaccess ubicado en la carpeta administrator
			   #AllowOverride AuthConfig
			   AuthType Basic
			   AuthName "Restricted Files"
			   # (Following line optional)
			   # AuthBasicProvider file
			   AuthUserFile "/var/www/passwd/.htpasswd"
			   #Con esta entrarían solo el usuario neo y delarioja
			   Require user neo delarioja
			   #Con esta entrarían solo los del grupo
			   #AuthGroupFile "/var/www/passwd/.htgroup"
			   #Require group Matrix
			   # y con esta cualquiera que salga en el fichero de usuarios
			   #Require valid-user
		</Directory>
		#Añadimos seguridad con SSL a esa autenticación Basic que no va encriptada, esto forzará a que se tenga que navegar por https://www.delarioja.red o https://www.delarioja.red:80
		SSLEngine On
		SSLCertificateFile /etc/apache2/ssl/certi-delarioja.pem
		SSLCertificateKeyFile /etc/apache2/ssl/clave-delarioja.pem
		# otras que no son necesarias pero se podrían descomentar
		#SSLCipherSuite RSA:+HIGH:+MEDIUM
		#SSLProtocol all
	</VirtualHost>
EOF

    read -p "Habilito módulos userdir y ssl y abro puerto 8080 (Pulsa Enter)"
    a2enmod userdir ssl
	echo "Listen 8080" >> /etc/apache2/ports.conf
	
    read -p "Activando sitios y reiniciando (Pulse Enter)"
     a2ensite intranet
     a2ensite web
     echo "Ejecutando systemctl restart apache2"; sleep 1
     systemctl restart apache2

read -p "Generando .htaccess en carpeta public_html del usuario delarioja y usuario apache válido (Pulse Enter para Continuar)"

tee /home/delarioja/public_html/.htaccess <<'EOF'
	<Files ~ "\.(gif|jpe?g|png)$">
		Require all denied
	</Files>
	AuthType Basic
	AuthName "Restricted Files"
	AuthUserFile "/home/delarioja/.htpasswd"
	Require valid-user
EOF

# LLEGA EL MOMENTO DE LAS COMPROBACIONES
    tree /var/www/www.delarioja.red
    read -p "Es momento de navegar todas las posibilidades de https://www.delarioja.red/ no-esta.html blog administrator y ¡puerto 80 en https! (pulsa Enter para Continuar y luego cierra el navegador que se abre)"
	chromium-browser --no-sandbox https://www.delarioja.red/no-esta.html https://www.delarioja.red/blog https://www.delarioja.red/administrator https://www.delarioja.red:80 http://www.delarioja.red:443

    tree /var/www/intranet.delarioja.red
    read -p "Es momento de navegar todas las posibilidades de http://intranet.delarioja.red:8080 no-esta.html: Mostrará un error en base al mensaje; wiki: se verá wiki.html pero si se pone otra página Forbidden porque -Indexes; privada: pedirá validación y mostrará +Indexes porque no encuentra el DirectoryIndex configurado (pulsa Enter para Continuar y luego cierra el navegador que se abre)"
	chromium-browser --no-sandbox http://intranet.delarioja.red:8080/no-esta.html http://intranet.delarioja.red:8080/wiki/wiki.html http://intranet.delarioja.red:8080/privada

    # Probando módulo UserDir
    tree /home/delarioja/public_html
    read -p "Ahora comprueba navegando en http://www.delarioja.red/~delarioja/ (pulsa Enter para Continuar y luego cierra el navegador que se abre)"
    chromium-browser --no-sandbox https://www.delarioja.red/~delarioja http://intranet.delarioja.red:8080/~delarioja

    # Comentamos la desactivación de php para userdir
     sed -i 's/php_admin_flag engine Off/#php_admin_flag engine Off/g' /etc/apache2/mods-available/php7.2.conf
    # Ahora sí debería dejar php a usuarios
	echo "Ejecutando systemctl reload apache2 para permitir php a userdir"; sleep 1
	systemctl reload apache2
	chromium-browser --no-sandbox https://www.delarioja.red/~delarioja http://intranet.delarioja.red:8080/~delarioja
