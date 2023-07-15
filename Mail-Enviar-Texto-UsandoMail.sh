#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# --------------
#  Script de NiPeGun para enviar mail en una sola línea usando mail
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/Mail-Enviar-Texto-UsandoMail.sh | bash
# --------------

cCantArgsEsperados=3


cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

if [ $# -ne $cCantArgsEsperados ]
  then
    echo ""
    
    echo -e "${cColorRojo}Mal uso del script.${cFinColor} El uso correcto sería:"
    echo ""
    echo -e "EnviarMailA ${cColorVerde}[DirecciónDeCorreo] [Asunto] [Texto]${cFinColor}"
    echo ""
    echo "Ejemplo:"
    echo ' EnviarMailA pepe@pepe.com "Recordatorio de cita" "Acuérdate que quedamos para comer"'
    
    echo ""
    exit
  else
    # Comprobar si el paquete mailutils está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s mailutils 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo "  mailutils no está instalado. Iniciando su instalación..."
        echo ""
        apt-get -y update && apt-get -y install mailutils
        echo ""
      fi
    echo "$3" | mail -a "Content-Type: text/plain; charset=UTF-8" -s "$2" $1
fi

