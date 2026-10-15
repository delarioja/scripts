cd /tmp
wget --no-check-certificate -O installer.tgz "https://github.com/servisys/ispconfig_setup/tarball/master"
tar zxvf installer.tgz
cd *ispconfig*
bash install.sh
echo "https://www.howtoforge.com/tutorial/ispconfig-3-automated-installation-on-ubuntu-1804/"
echo "Pasamos a desinstalar spamd para que no impida a postfix funcionar correctamente"
apt-get -y remove spampd
service postfix restart
less /var/log/ispconfig_setup.log
