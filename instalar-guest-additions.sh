#!/bin/bash
# primero instala estos paquetes para resolver problemas de dependencias en la compilación de los drivers necesarios (de pantalla, disco y red principalmente):
sudo apt install dkms linux-headers-$(uname -r)
# luego en VirtualBox mete el CD desde menú Dispositivos -> "Insertar imagen de CD de los Complementos del invitado", si estás en Server móntalo, y finalmente ejecútalo:
sudo mount -r /dev/cdrom /mnt
sudo /mnt/VBoxLinuxAdditions.run