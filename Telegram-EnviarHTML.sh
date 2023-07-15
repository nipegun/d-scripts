#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para enviar HTML a Telegram desde Bash usando un bot
#
#  Etiquetas soportadas:
#
#  <b>bold</b>
#  <strong>bold</strong>
#  <i>italic</i>
#  <em>italic</em>
#  <u>underline</u>
#  <ins>underline</ins>
#  <s>strikethrough</s>
#  <strike>strikethrough</strike>
#  <del>strikethrough</del>
#  <span class="tg-spoiler">spoiler</span>
#  <tg-spoiler>spoiler</tg-spoiler>
#  <b>bold <i>italic bold <s>italic bold strikethrough <span class="tg-spoiler">italic bold strikethrough spoiler</span></s> <u>underline italic bold</u></i> bold</b>
#  <a href="http://www.example.com/">inline URL</a>
#  <a href="tg://user?id=123456789">inline mention of a user</a>
#  <code>inline fixed-width code</code>
#  <pre></pre>
#  <pre><code class="language-python"></code></pre>
#
# ----------

cColorRojo="\033[1;31m"
cColorVerde="\033[1;32m"
cFinColor="\033[0m"

cCantArgumEsperados=3


if [ $# -ne $cCantArgumEsperados ]
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
      curl -sL -X POST $URL -d chat_id=$IdDestino -d parse_mode=HTML -d text="$Mensaje" > /dev/null
      echo ""
    else
      echo ""
      echo -e "${cColorRojo}No se pudo enviar el mensaje porque no se pudo contactar con https://api.telegram.org${cFinColor}"
      echo ""
    fi
fi

