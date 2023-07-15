#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  SCRIPT DE NIPEGUN PARA REACTIVAR UN CERTIFICADO LETSENCRYPT YA VENCIDO
#  PARA UN DOMINIO ALOJADO EN UN SERVIDOR DE APACHE
# ----------

cCantArgsCorrectos=1


if [ $# -ne $cCantArgsCorrectos ]
  then
    echo ""
    
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: $0 [Dominio o Subdominio]"
    echo ""
    echo "Ejemplo:"
    echo ' $0 hacks4geeks.com'
    
    echo ""
    exit
  else
   /root/git/letsencrypt/certbot-auto --authenticator standalone --installer apache -d $1
fi

