#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.
https://docs.vultr.com/how-to-install-overleaf-community-edition-on-ubuntu-20-04-lts
# ----------
# Script de NiPeGun para instalar y configurar Overleaf en Debian
#
# Ejecución remota con sudo:
#   curl -sL x | sudo bash
#
# Ejecución remota como root:
#   curl -sL x | sudo bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' x | bash
#
# Ejecución remota con parámetros:
#   curl -sL x | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL x | nano -
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  #if [ $(id -u) -ne 0 ]; then     # Sólo comprueba si es root
  if [[ $EUID -ne 0 ]]; then       # Comprueba si es root o sudo
    echo ""
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse con privilegios de administrador (como root o con sudo).${cFinColor}"
    echo ""
    exit
  fi

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

# Ejecutar comandos dependiendo de la versión de Debian detectada

  if [ $cVerSO == "13" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Overleaf para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Overleaf para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    cd /opt
    # Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${cColorRojo}  El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
        echo ""
        apt-get -y update && apt-get -y install git
        echo ""
      fi
      git clone https://github.com/overleaf/toolkit.git ./overleaf
      adduser overleaf
      chown -R overleaf:overleaf /opt/overleaf
      
      # Initialize Overleaf local environment with the --tls flag to enable Transport Layer Security (TLS):
        cd /opt/overleaf
        bin/init --tls
        echo ""
        echo "  Certificado autofirmado guardado como       /opt/overleaf/config/nginx/certs/overleaf_certificate.pem"
        echo "  Clave pública correspondiente guardada como /opt/overleaf/config/nginx/certs/overleaf_key.pem"

      # Set environment variables for running Overleaf Community Edition behind the Nginx TLS proxy:
        sed -i -e 's|# SHARELATEX_BEHIND_PROXY=true|SHARELATEX_BEHIND_PROXY=true|g'   /opt/overleaf/config/variables.env
        sed -i -e 's|# SHARELATEX_SECURE_COOKIE=true|SHARELATEX_SECURE_COOKIE=true|g' /opt/overleaf/config/variables.env

      # Personalización
        sed -i -e 's|SHARELATEX_APP_NAME=Our Overleaf Instance|SHARELATEX_APP_NAME=Mi overleaf|g' /opt/overleaf/config/variables.env
        sed -i -e 's|# SHARELATEX_SITE_URL=http://overleaf.example.com|SHARELATEX_SITE_URL=http://overleaf.example.com|g'                        /opt/overleaf/config/variables.env
        sed -i -e 's|# SHARELATEX_NAV_TITLE=Our Overleaf Instance|# SHARELATEX_NAV_TITLE=Our Overleaf Instance|g' /opt/overleaf/config/variables.env
        sed -i -e 's|# SHARELATEX_HEADER_IMAGE_URL=http://somewhere.com/mylogo.png|SHARELATEX_HEADER_IMAGE_URL=http://somewhere.com/mylogo.png|g' /opt/overleaf/config/variables.env
        sed -i -e 's|# SHARELATEX_ADMIN_EMAIL=support@example.com|# SHARELATEX_ADMIN_EMAIL=support@example.com|g' /opt/overleaf/config/variables.env
        sed -i -e 's|# SHARELATEX_RIGHT_FOOTER=[{"text":"Hello I am on the Right"}]|# SHARELATEX_RIGHT_FOOTER=[{"text":"Hello I am on the Right"}]|g' /opt/overleaf/config/variables.env
        sed -i -e 's|# SHARELATEX_LEFT_FOOTER=[{"text":"Powered by Overleaf © 2021", "url": "https://www.overleaf.com"}, {"text": "Contact your support team", "url": "mailto:support@example.com"} ]||g' /opt/overleaf/config/variables.env

https://docs.vultr.com/how-to-install-overleaf-community-edition-on-ubuntu-20-04-lts

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Overleaf para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Overleaf para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Overleaf para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Overleaf para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Overleaf para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
