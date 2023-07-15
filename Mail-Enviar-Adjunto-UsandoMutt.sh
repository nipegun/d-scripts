#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# -----------
#  Script de NiPeGun para enviar mail en una sola línea usando mutt
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/Mail-Enviar-Adjunto-UsandoMutt.sh | bash
# -----------

cCantArgsEsperados=4


cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

if [ $# -ne $cCantArgsEsperados ]
  then
    echo ""
    echo "-----------------------------------------------------------------------------------------------------------------------------------------"
    echo -e "${cColorRojo}Mal uso del script.${cFinColor} El uso correcto sería:"
    echo ""
    echo -e "EnviarMailA ${cColorVerde}[DirecciónDeCorreo] [Asunto] [Texto] [RutaAlArchivoAAdjuntar]${cFinColor}"
    echo ""
    echo "Ejemplo:"
    echo ' Mail-Enviar-Adjunto-UsandoMutt.sh pepe@pepe.com "Recordatorio de cita" "Acuérdate que quedamos para comer" "/home/usuario/archivo.zip"'
    echo "-----------------------------------------------------------------------------------------------------------------------------------------"
    echo ""
    exit
  else
    # Comprobar si el paquete mutt está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s mutt 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo "  mutt no está instalado. Iniciando su instalación..."
        echo ""
        apt-get -y update && apt-get -y install mutt
        echo ""
      fi
    echo "$3" | mutt -s "$2" $1 -a "$4"
fi

