 #!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para agregar usuarios a uHub
# ----------

cCantArgumEsperados=2

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

if [ $# -ne $cCantArgsEsperados ]
  then
    echo ""
    echo "---------------------------------------------------------------------------"
    echo -e "${cColorRojo}Mal uso del script.${cFinColor} El uso correcto sería:"
    echo -e "$0 ${cColorVerde}[NombreDeUsuario] [Contraseña]${cFinColor}"
    echo ""
    echo "Ejemplo:"
    echo "$0 pepe 12345678"
    echo "---------------------------------------------------------------------------"
    echo ""
    exit
  else
    echo ""
    echo -e "${cColorVerde}Agregando el nuevo usuario a uHub...${cFinColor}"
    echo ""
    uhub-passwd /etc/uhub/users.db add $1 $2
    systemctl restart uhub.service
fi

