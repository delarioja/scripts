#!/bin/bash
sudo apt update
curl -fsSL https://download.webmin.com/jcameron-key.asc | sudo gpg --dearmor -o /usr/share/keyrings/webmin.gpg
sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/webmin.gpg] https://download.webmin.com/download/newkey/repository sarge contrib" >> /etc/apt/sources.list'
sudo apt update
sudo apt install webmin -y
#sudo ufw allow 10000/tcp