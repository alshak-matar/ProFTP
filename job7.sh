#!/bin/bash
apt-get install update
apt-get install upgrade
apt-get install sudo
sudo apt-get install proftpd
sudo systemctl enable proftpd.service
chmod 777 /etc/proftpd/proftpd.conf
sed '<164,203>/^#/d' /etc/proftpd/proftpd.conf  #Pour activer les connexions anonymes
mkdir /etc/proftpd/ssl
openssl req -new -x509 -days 365 -nodes -out /etc/proftpd/ssl/proftpd.cert.pem -keyout /etc/proftpd/ssl/proftpd.key.pem
chmod 600 /etc/proftpd/ssl/proftpd.*
sed '<143>/^#/d' /etc/proftpd/proftpd.conf 
sed -i 's/<9,58>/<IfModule mod_tls.c>
TLSEngine                  on
TLSLog                     /var/log/proftpd/tls.log
TLSProtocol TLSv1.2
TLSCipherSuite AES128+EECDH:AES128+EDH
TLSOptions                 NoCertRequest AllowClientRenegotiations
TLSRSACertificateFile      /etc/proftpd/ssl/proftpd.cert.pem
TLSRSACertificateKeyFile   /etc/proftpd/ssl/proftpd.key.pem
TLSVerifyClient            off
TLSRequired                on
RequireValidShell          no
</IfModule>' /etc/proftpd/tls.conf 
sudo service proftpd restart
ip a
