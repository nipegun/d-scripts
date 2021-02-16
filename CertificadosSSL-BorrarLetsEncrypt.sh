#!/bin/bash

Dominio="nipegun.com"

echo ""
echo ""
echo ""
rm -rf /etc/letsencrypt/live/$Dominio
rm /etc/letsencrypt/renewal/$Dominio.conf

echo ""
echo ""
echo ""
rm -rf /etc/letsencrypt/live/www.$Dominio
rm /etc/letsencrypt/renewal/www.$Dominio.conf

echo ""
echo ""
echo ""
sed -i -e 's|Include /etc/letsencrypt/options-ssl-apache.conf|#Include /etc/letsencrypt/options-ssl-apache.conf|g' /etc/apache2/sites-available/$Dominio.conf 
sed -i -e 's|SSLCertificateFile /etc/letsencrypt/live/'"$Dominio"'/fullchain.pem|#SSLCertificateFile /etc/letsencrypt/live/'"$Dominio"'/fullchain.pem|g'   /etc/apache2/sites-available/$Dominio.conf 
sed -i -e 's|SSLCertificateKeyFile /etc/letsencrypt/live/'"$Dominio"'/privkey.pem|#SSLCertificateKeyFile /etc/letsencrypt/live/'"$Dominio"'/privkey.pem|g' /etc/apache2/sites-available/$Dominio.conf 

echo ""
echo "/etc/apache2/sites-available/$Dominio.conf"
echo "SSLCertificateKeyFile /etc/letsencrypt/live/$Dominio/privkey.pem"

