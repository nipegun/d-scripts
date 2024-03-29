#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para hacer una copia de seguridad de una web específica
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Web-Apache-Exportar.sh | bash -s pepe.com pepe 1234 pepedb
# ----------

cCantArgumEsperados=4
v

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

if [ $# -ne $cCantArgsEsperados ]
  then
    echo ""
    
    echo -e "${cColorRojo}Mal uso del script.${cFinColor} El uso correcto sería:"
    echo ""
    echo -e "$0 ${cColorVerde}[NombreDeLaWebEnApache] [UsuarioBD] [PasswordBD] [NombreBD]${cFinColor}"
    echo ""
    echo "Ejemplo:"
    echo ' $0 pepe.org pepe'
    
    echo ""
    exit
  else
    echo ""
    echo -e "${cColorVerde}  Ejecutando la copia de seguridad...${cFinColor}"
    echo ""
    mkdir -p /CopSeg/$1/etc/apache2/sites-available/
    cp /etc/apache2/sites-available/$1.conf /CopSeg/$1/etc/apache2/sites-available/
    cp /etc/apache2/sites-available/$1-le-ssl.conf /CopSeg/$1/etc/apache2/sites-available/
    mkdir -p /CopSeg/$1/var/www/$1/
    cp -R /var/www/$1/* /CopSeg/$1/var/www/$1/
    /root/scripts/d-scripts/MySQL-BaseDeDatos-Exportar.sh $2 $3 $4 /CopSeg/$1/BaseDeDatos.sql
    tar -czvf /CopSeg/$1.tar.gz /CopSeg/$1/
    rm -rf /CopSeg/$1/
    vFechaDeEjec=$(date +A%Y-M%m-D%d@%T)
    mv /CopSeg/$1.tar.gz /CopSeg/$1-$vFechaDeEjec.tar.gz
fi

