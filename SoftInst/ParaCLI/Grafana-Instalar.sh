#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar Grafana en Debian
#
#  Ejecución remota
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Grafana-Instalar.sh | bash
#------------------------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

## Determinar la versión de Debian

   if [ -f /etc/os-release ]; then
       # Para systemd y freedesktop.org
       . /etc/os-release
       OS_NAME=$NAME
       OS_VERS=$VERSION_ID
   elif type lsb_release >/dev/null 2>&1; then
       # linuxbase.org
       OS_NAME=$(lsb_release -si)
       OS_VERS=$(lsb_release -sr)
   elif [ -f /etc/lsb-release ]; then
       # Para algunas versiones de Debian sin el comando lsb_release
       . /etc/lsb-release
       OS_NAME=$DISTRIB_ID
       OS_VERS=$DISTRIB_RELEASE
   elif [ -f /etc/debian_version ]; then
       # Para versiones viejas de Debian.
       OS_NAME=Debian
       OS_VERS=$(cat /etc/debian_version)
   else
       # Para el viejo uname (También funciona para BSD)
       OS_NAME=$(uname -s)
       OS_VERS=$(uname -r)
   fi

if [ $OS_VERS == "7" ]; then

  echo ""
  echo "---------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Grafana para Debian 7 (Wheezy)..."
  echo "---------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "---------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Grafana para Debian 8 (Jessie)..."
  echo "---------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Grafana para Debian 9 (Stretch)..."
  echo "----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Grafana para Debian 10 (Buster)..."
  echo "----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Grafana para Debian 11 (Bullseye)..."
  echo "------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Instalando dependencias o paquetes necesarios para el script..."
  echo ""
  apt-get update
  apt-get -y insall wget
  apt-get -y install gnupg
  #apt-get -y install apt-transport-https
  #apt-get -y install software-properties-common

  echo ""
  echo "  Importando clave del repositorio.."
  echo ""
  ## Para cuando apt-key quede obsoleto:
     # mkdir -p /root/aptkeys/
     # wget -q -O- https://packages.grafana.com/gpg.key > /root/aptkeys/grafana.key
     # gpg --dearmor /root/aptkeys/grafana.key
     # cp /root/aptkeys/grafana.key.gpg /usr/share/keyrings/grafana.gpg
   wget -q -O - https://packages.grafana.com/gpg.key | apt-key add -

  echo ""
  echo "  Agregando repositorio..."
  echo ""
  echo "deb https://packages.grafana.com/enterprise/deb stable main" > /etc/apt/sources.list.d/grafana.list

  echo ""
  echo "  Instalando paquetes..."
  echo ""
  apt-get update
  apt-get -y install grafana-enterprise

  ## Preparar para https
     #cd /etc/grafana
     #openssl genrsa -out grafana.key 2048
     #openssl req -new -key grafana.key -out grafana.csr
     #openssl x509 -req -days 365 -in grafana.csr -signkey grafana.key -out grafana.crt
     #chown grafana:grafana grafana.crt
     #chown grafana:grafana grafana.key
     #chmod 400 grafana.key grafana.crt
     #sed -i -e 's|;protocol = http|protocol = https|g'                 /etc/grafana/grafana.ini
     #sed -i -e 's|;cert_file =|cert_key = /etc/grafana/grafana.key|g'  /etc/grafana/grafana.ini
     #sed -i -e 's|;key_file =|cert_file = /etc/grafana/grafana.crt|g'  /etc/grafana/grafana.ini
     
  ## Permitir embedded
     sed -i -e 's|;allow_embedding = false|allow_embedding = true|g'   /etc/grafana/grafana.ini
     sed -i -e 's|;cookie_samesite = lax|cookie_samesite = disabled|g' /etc/grafana/grafana.ini

  echo ""
  echo "  Activando el servicio..."
  echo ""
  systemctl enable grafana-server --now

fi

