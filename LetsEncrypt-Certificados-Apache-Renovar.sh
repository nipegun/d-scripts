#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para renovar certificados LetsEncrypt
#
#  Más info aquí:
#  https://certbot.eff.org/lets-encrypt/debianstretch-apache
# ----------

echo ""
echo "Comprobando si falta algún paquete e instálándolo..."echo ""
# apt-get -t stretch-backports
apt-get -y update
apt-get install certbot python-certbot-apache

echo ""
echo "Ejecutando el bot de certificados para apache..."echo ""
# certbot --apache # Te autoconfigura el .conf de apache 
certbot --apache certonly # Te premite configurar el .conf de apache manualemnte

# The Certbot packages on your system come with a cron job that will
# renew your certificates automatically before they expire. Since
# Let's Encrypt certificates last for 90 days, it's highly advisable
# to take advantage of this feature. You can test automatic renewal
# for your certificates by running this command:
# certbot renew --dry-run

echo "certbot renew" >> /root/scripts/TareasCronCadaSemana.sh

