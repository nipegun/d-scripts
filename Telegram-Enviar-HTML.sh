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

cCantArgumEsperados=3

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Notificar el inicio de ejecución del script
  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script para enviar HTML con la API de Telegram...${cFinColor}"
  echo ""

if [ $# -ne $cCantArgumEsperados ]
  then
    echo ""
    echo -e "${cColorRojo}    Mal uso del script!${cFinColor}"
    echo ""
    echo "      El uso correcto sería:"
    echo ""
    echo "        $0 'TokenDelBot' 'IdDelChatDeDestino' 'Mensaje'"
    echo ""
    echo "      Por ejemplo:"
    echo ""
    echo "        $0 '123456789:AAAAAAAAAA_AAAAAAAAAAAAAAA_AAAAAA_A' '000000000' '<b>Empresa: </b><a>Google</a> %0A <b>Enlace a su web: </b><a href="'"http://google.es"'">aquí</a>'"
    echo ""
    exit
  else
    # Comprobar que haya acceso a la API de Telegram antes de Intentar enviar
      wget -q --tries=10 --timeout=20 --spider https://api.telegram.org
      if [[ $? -eq 0 ]]
        then
          vTokenDelBot="$1"
          vURL="https://api.telegram.org/bot$vTokenDelBot/sendMessage"
          vIdDestino="$2"
          vMensaje="$3"
          curl -sL -X POST $vURL -d chat_id=$vIdDestino -d parse_mode=HTML -d text="$vMensaje" > /dev/null
          echo ""
        else
          echo ""
          echo -e "${cColorRojo}  No se pudo enviar el mensaje porque no se pudo contactar con https://api.telegram.org${cFinColor}"
          echo ""
      fi
fi

