#!/bin/bash
# Shell Script para aprender directivas de Apache donde generaremos una Entidad certificadora que también se instalará en nuestros navegadores de la empresa para que no de error de certificado no contrastado/confiable
# Fernando Barcina - Nov-2018
clear
echo "Comprobamos si esta instalado openssl ..."
if test $(dpkg --get-selections | grep "^openssl" | wc -l) -eq 0; then
    apt-get install openssl
else
    echo "Ya esta instalado openssl. Pulsa una tecla para continuar"
    read
fi
echo "Creamos la entidad certificadora. Claves y certificado ..."
mkdir /etc/apache2/entidadca
cd /etc/apache2/entidadca
openssl genrsa -out CA-clave.pem 2048
openssl req -new -x509 -key CA-clave.pem -out CA-certificado.pem -days 500
echo "Generamos el certificado *.p12 de la CA para plataformas Windows"
openssl pkcs12 -export -out CA-certificado.p12 \
    -inkey CA-clave.pem -in CA-certificado.pem -certfile CA-certificado.pem
echo "Pasamos a generar las claves y certificados de los 2 sitios web. Pulsa Una tecla para
continuar ..."
read
mkdir /etc/apache2/certsitio1
cd /etc/apache2/certsitio1
openssl genrsa -out Sitio1-clave.pem 2048
echo "Creamos la solicitud del certificado del sitio1..."
openssl req -new -key Sitio1-clave.pem -out Sitio1-certificado.p10
echo "Ahora la CA firma la solicitud del sitio1..."
openssl x509 -req -in Sitio1-certificado.p10 \
    -out Sitio1-certificado.pem \
    -CA ../entidadca/CA-certificado.pem -CAkey ../entidadca/CA-clave.pem \
    -CAcreateserial -days 110
mkdir /etc/apache2/certsitio2
cd /etc/apache2/certsitio2
openssl genrsa -out Sitio2-clave.pem 2048
echo "Creamos la solicitud del certificado del sitio2 …"
openssl req -new -key Sitio2-clave.pem -out Sitio2-certificado.p10
echo "Ahora la CA firma la solicitud del sitio2 ..."
openssl x509 -req -in Sitio2-certificado.p10 \
    -out Sitio2-certificado.pem \
    -CA ../entidadca/CA-certificado.pem -CAkey ../entidadca/CA-clave.pem \
    -CAcreateserial -days 170
(
    cat <<'FINAL'
<VirtualHost 192.168.1.100:8080>
ServerName "intranet.delarioja.org"
DocumentRoot /var/www/intranet
DirectoryIndex sitio1.html inicial.html
# Definimos Alias para el acceso a directorios fuera del sitio Web
Alias /imagenes /mnt/imagenes
Alias /videos /mnt/videos
# Permitimos la publicación de contenidos Web desde el Home de los usuarios
UserDir /home/*/www
UserDir enabled
# Asignamos valor a las directivas relacionadas con la capa de seguridad SSL
SSLEngine on
SSLCipherSuite RSA:+HIGH:+MEDIUM
SSLProtocol all
SSLCertificateFile /etc/apache2/certsitio1/Sitio1-certificado.pem
SSLCertificateKeyFile /etc/apache2/certsitio1/Sitio1-clave.pem
SSLCACertificateFile /etc/apache2/entidadca/CA-certificado.pem
<Directory /var/www/sitiow1>
Allow from all
</Directory>
</VirtualHost>
<VirtualHost *:443>
 ServerName "web.delarioja.org"
 DocumentRoot /var/www/web
 DirectoryIndex sitio2.html inicial.html
# Definimos Alias para el acceso a directorios fuera del sitio Web
 Alias /imagenes /mnt/imagenes
 Alias /videos /mnt/videos
# Permitimos la publicación de contenidos Web desde el Home de los usuarios
 UserDir /home/*/public_html
UserDir enabled
# Asignamos valor a las directivas relacionadas con la capa de seguridad SSL
 SSLEngine on
 SSLCipherSuite RSA:+HIGH:+MEDIUM
SSLProtocol all
SSLCertificateFile /etc/apache2/certsitio2/Sitio2-certificado.pem
SSLCertificateKeyFile /etc/apache2/certsitio2/Sitio2-clave.pem
SSLCACertificateFile /etc/apache2/entidadca/CA-certificado.pem
 <Directory /var/www/sitiow2>
 Allow from all
 </Directory>
# Definimos las áreas de acceso restringido del sitio Web
<Directory /var/www/sitiow2/Descargas/privado>
AuthType Digest
AuthName "Area Privada 1"
AuthDigestProvider file
AuthUserFile /etc/apache2/control/area1.dat
Require valid-user
</Directory>
<Directory /var/www/sitiow2/Descargas>
<Files informacion.html>
 AuthType Basic
 AuthName "Area Privada 2"
 AuthBasicProvider dbm
 AuthDBMType SDBM
 AuthDBMUserFile /etc/apache2/control/area2.db
 Require valid-user
 </Files>
</Directory>
</VirtualHost>
FINAL
) >/etc/apache2/sites-available/sitios-seguros.conf
a2ensite sitios-seguros.conf
a2enmod ssl userdir auth_digest authn_dbm
