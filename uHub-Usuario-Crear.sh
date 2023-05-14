 #!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------
#  Script de NiPeGun para agregar usuarios a uHub
#--------------------------------------------------

CantArgsEsperados=2
ArgsInsuficientes=65

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

if [ $# -ne $CantArgsEsperados ]
  then
    echo ""
    echo "---------------------------------------------------------------------------"
    echo -e "${ColorRojo}Mal uso del script.${FinColor} El uso correcto sería:"
    echo -e "$0 ${ColorVerde}[NombreDeUsuario] [Contraseña]${FinColor}"
    echo ""
    echo "Ejemplo:"
    echo "$0 pepe 12345678"
    echo "---------------------------------------------------------------------------"
    echo ""
    exit $ArgsInsuficientes
  else
    echo ""
    echo -e "${ColorVerde}Agregando el nuevo usuario a uHub...${FinColor}"
    echo ""
    uhub-passwd /etc/uhub/users.db add $1 $2
    systemctl restart uhub.service
fi

