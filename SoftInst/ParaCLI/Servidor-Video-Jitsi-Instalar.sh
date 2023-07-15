#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar jitsi-meet
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-Video-Jitsi-Instalar.sh | bash
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

if [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 7 (Wheezy)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 8 (Jessie)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 9 (Stretch)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 10 (Buster)..."  
  echo ""

  vCantParamCorr=1
  apt-get -y update > /dev/null
  # Paquetes necesarios
  apt-get -y install jq dialog software-properties-common > /dev/null
  
  menu=(dialog --timeout 5 --checklist "Instalación y configuración de jitsi-meet:" 22 76 16)
    opciones=(
  1 "Instalar jitsi-meet" on
              2 "Instalar certificado de LetsEncrypt" off
              3 "Activar autentificación para crear salas" off
              4 "Modificar título y descripción" off
              5 "Poner logo transparente" off
              6 "Cambiar lenguaje por defecto a Español" off
)
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
    clear

    for choice in $choices
      do
        case $choice in

          1)
            if [ $# -ne $vCantParamCorr ]; then

              echo ""
              echo -e "${cColorRojo}Mal uso del script. Se le debe pasar un parámetro obligatorio:${cFinColor}"
              echo ""
              echo -e "${cColorVerde}[Dominio]${cFinColor}"
              echo ""
              echo "Ejemplo:"
              echo ""
              echo -e "$0 ${cColorVerde}video.dominio.com${cFinColor}"
              echo ""
              echo "Recuerda que antes debes crear y activar el dominio en apache."
              echo ""
              exit

            else

              echo ""
              echo -e "${cColorVerde}Instalando jitsi-meet...${cFinColor}"
              echo ""
  
              #HostName=$(cat /etc/hostname)
              #echo "127.0.0.1 $HostName" >> /etc/hosts
              echo "127.0.0.1 $1" >> /etc/hosts

              # Instalar la llave del repositorio
              wget -qO - https://download.jitsi.org/jitsi-key.gpg.key | apt-key add -

              # Crear un archivo de fuentes con el repositorio
              sh -c "echo 'deb https://download.jitsi.org stable/' > /etc/apt/sources.list.d/jitsi-stable.list"

              # Actualizar la lista de paquetes:
              apt-get -y update

              #Instalar la suite
              apt-get -y install jitsi-meet

              # Si no necesitas la suite completa puedes instalar paquetes individuales
              # apt-get -y install jitsi-videobridge
              # apt-get -y install jicofo
              # apt-get -y install jigasi

              service prosody            restart
              service jicofo             restart
              service jitsi-videobridge2 restart

            fi
          ;;
       
          2)
            /usr/share/jitsi-meet/scripts/install-letsencrypt-cert.sh
          ;;

          3)
            echo ""
            echo "  Agregando autentificación para crear canales..."
            echo ""
            sed -i -e 's|authentication = "anonymous"|authentication = "internal_plain"|g' /etc/prosody/conf.avail/$1.cfg.lua
            echo "" >> /etc/prosody/conf.avail/$1.cfg.lua
            echo 'VirtualHost "guest.'"$1"'"'           >> /etc/prosody/conf.avail/$1.cfg.lua
            echo '  authentication = "anonymous"'   >> /etc/prosody/conf.avail/$1.cfg.lua
            echo "  c2s_require_encryption = false" >> /etc/prosody/conf.avail/$1.cfg.lua
            echo "org.jitsi.jicofo.auth.URL=XMPP:$1" >>  /etc/jitsi/jicofo/sip-communicator.properties
            service prosody            restart
            service jicofo             restart
            service jitsi-videobridge2 restart
          ;;

          4)
            echo ""
            echo "  Modificando título y descripción..."
            echo ""
            for ArchivoReal in /usr/share/jitsi-meet/lang/main*.json
              do
                ArchivoTemporalTitle=$(mktemp)
                jq '.welcomepage.title = "'"$1"'"' $ArchivoReal > $ArchivoTemporalTitle && mv $ArchivoTemporalTitle $ArchivoReal
                ArchivoTemporalDesc=$(mktemp)
                jq '.welcomepage.appDescription = "---"' $ArchivoReal > $ArchivoTemporalDesc && mv $ArchivoTemporalDesc $ArchivoReal
              done
            service prosody            restart
            service jicofo             restart
            service jitsi-videobridge2 restart
          ;;

          5)
            echo ""
            echo "  Poniendo logo transparente..."
            echo ""
            cp /usr/share/jitsi-meet/images/watermark.png /usr/share/jitsi-meet/images/watermark.png.bak
            truncate -s 0 /usr/share/jitsi-meet/images/watermark.png
          ;;
        
          6)
            echo ""
            echo "  Poniendo lenguaje en español de España..."
            echo ""
            sed -i -e "s|// defaultLanguage: 'en',|defaultLanguage: 'es',|g" /etc/jitsi/meet/$1-config.js
          ;;
        
        esac

  done

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 11 (Bullseye)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

fi

