#!/bin/bash

#-
# Si el comando:
# certbot delete
# no te funciona, usa este script
#-

Dominio="nipegun.com"

echo ""
echo ""
echo ""
rm -rf /etc/letsencrypt/archive/$Dominio
rm -rf /etc/letsencrypt/live/$Dominio
rm -rf /etc/letsencrypt/renewal/$Dominio.conf

echo ""
echo ""
echo ""
sed -i -e 's|Include /etc/letsencrypt/options-ssl-apache.conf|#Include /etc/letsencrypt/options-ssl-apache.conf|g' /etc/apache2/sites-available/$Dominio-ssl.conf
sed -i -e 's|SSLCertificateFile /etc/letsencrypt/live/'"$Dominio"'/fullchain.pem|#SSLCertificateFile /etc/letsencrypt/live/'"$Dominio"'/fullchain.pem|g'   /etc/apache2/sites-available/$Dominio-ssl.conf
sed -i -e 's|SSLCertificateKeyFile /etc/letsencrypt/live/'"$Dominio"'/privkey.pem|#SSLCertificateKeyFile /etc/letsencrypt/live/'"$Dominio"'/privkey.pem|g' /etc/apache2/sites-available/$Dominio-ssl.conf

