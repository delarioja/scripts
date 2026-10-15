#! /bin/bash
# EJERCICIO1
# Habla de un profesor que es un usuario
adduser profesor
#y 4 de sus alumnos
adduser alumno1 && adduser alumno2 && adduser alumno3 && adduser alumno4
#Los agrupamos
addgroup grupo1 && addgroup grupo2

#Directorios creados automáticamente (/home/alumno1, /home/alumno2, /home/alumno3, /home/alumno4, /home/profesor)
#Archivos creados (./alumno1/practica_individual1)
touch /home/alumno1/practica_individual1 /home/alumno2/practica_individual2 /home/alumno3/practica_individual3 /home/alumno4/practica_individual4
chmod 640 /home/alumno[1-4]/practica*
adduser profesor alumno1
adduser profesor alumno2
adduser profesor alumno3
adduser profesor alumno4
#podrían haberse puesto en uno solo aprendiendo a utilizar usermod
#usermod -aG alumno1,alumno2,alumno3,alumno4 profesor

#Otras soluciones posibles:
#en vez de meter a profesor en el grupo alumnoX también podría haberse cambiado los grupos propietarios
#chown :profesor /home/alumno[1-4]/practica*
#y si en el futuro los usuarios crean nuevas practicas con otros permisos podría evitar cotillas si quito el permiso de lectura y acceso que tienen las carpetas creadas por defecto para "otros"
#chmod 750 /home/alumno[1-4]
	
	sudo chown -R apache:apache .
    -or-
    sudo chown -R nginx:nginx .
    sudo find . -type d -exec chmod 755 {} \;
    sudo find . -type f -exec chmod 664 {} \;
	
# EJERCICIO2
#Directorios creados (./grupo1, ./grupo2)
mkdir /home/grupo1 /home/grupo2

chown profesor:grupo1 /home/grupo1
chown profesor:grupo2 /home/grupo2
#Solo usuarios de grupo podrán modificar, profesor podrá leer y editar
chmod 2770 /home/grupo[1-2]
# Establecemos el bit setgid para que cuando alguien de los grupos cree un futuro fichero, éste quede con el grupo propietario de la carpeta y por tanto pueda seguir siendo editado por el profesor dado que a continuación lo metemos en dichos grupos
usermod -aG grupo1,grupo2 profesor
# Otra manera de hacerlo es establecer como grupo principal de los alumnos los grupos mencionados (usuario1, usuario2 -> grupo1; usuario3, usuario4 -> grupo2) de manera que cuando creen ficheros pertenezcan siempre al grupo propietario correspondiente
usermod -g grupo1 alumno1 && usermod -g grupo1 alumno2 && usermod -g grupo2 alumno3 && usermod -g grupo2 alumno4

#Crear directorio (/home/clase_linux)
addgroup linuxeros
mkdir /home/clase_linux
adduser alumno1 linuxeros
adduser alumno2 linuxeros
adduser alumno3 linuxeros
adduser alumno4 linuxeros
adduser alumno5
#Podrán ser leídos y modificados por usuarios y profesor
touch /home/clase_linux/archivoal1 /home/clase_linux/archivoal2 /home/clase_linux/archivoal3 /home/clase_linux/archivoal4
chown alumno1 /home/clase_linux/archivoal1 && chown alumno2 /home/clase_linux/archivoal2 && chown alumno3 /home/clase_linux/archivoal3 && chown alumno4 /home/clase_linux/archivoal4

chown -R profesor:linuxeros /home/clase_linux
chmod 575 /home/clase_linux
chmod 464 /home/clase_linux/*



# Ahora vendrían las comprobaciones, para esto usaremos:
# para leer: ls y cat para carpetas y ficheros respectivamente
# para escribir/modificar: touch o echo texto >fichero para escribir en carpetas; nano/gedit o echo texto >>fichero para escribir ficheros
# para acceder carpeta: cd carpeta , y para ejecutar fichero: ./fichero 
