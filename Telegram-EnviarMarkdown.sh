#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# --------------
#  Script de NiPeGun para enviar MarkDown a Telegram desde Bash usando un bot
# --------------

ColorAdvertencia="\033[1;31m"
ColorArgumentos="\033[1;32m"
cFinColor="\033[0m"

cCantArgsCorrectos=3

if [ $# -ne $cCantArgsCorrectos ]
  then
    echo ""
    echo -e "${cColorRojo}Mal uso del script!${cFinColor}"
    echo ""
    echo -e 'El uso correcto sería: '$0' '${cColorVerde}'[TokenDelBot] [IdDelChatDeDestino] ["Mensaje"]'${cFinColor}''
    echo ""
    echo "Ejemplo:"
    echo ""
    echo ''$0' 123456789:AAAAAAAAAA_AAAAAAAAAAAAAAA_AAAAAA_A 000000000 "Mensaje de prueba"'
    echo ""
    exit
  else
    wget -q --tries=10 --timeout=20 --spider https://api.telegram.org
    if [[ $? -eq 0 ]]; then
      TokenDelBot="$1"
      URL="https://api.telegram.org/bot$TokenDelBot/sendMessage"
      IdDestino="$2"
      Mensaje="$3"
      curl -s -X POST $URL -d chat_id=$IdDestino -d parse_mode=MarkdownV2 -d text="$Mensaje" > /dev/null
      echo ""
    else
      echo ""
      echo -e "${cColorRojo}No se pudo enviar el mensaje porque no se pudo contactar con https://api.telegram.org${cFinColor}"
      echo ""
    fi
fi
