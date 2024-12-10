#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar Grafana en Debian
#
# Ejecución remota
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Grafana-Instalar.sh | bash
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

if [ $cVerSO == "13" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Grafana para Debian 13 (x)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 13 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "12" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Grafana para Debian 11 (Bullseye)..."  
  echo ""

  echo ""
  echo "  Importando clave del repositorio.."
  echo ""
  mkdir -p /root/aptkeys/
  # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete wget no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update
      apt-get -y install wget
      echo ""
    fi
  wget -q -O- https://packages.grafana.com/gpg.key > /root/aptkeys/grafana.key
  # Comprobar si el paquete gnupg2 está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s gnupg2 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete gnupg2 no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update
      apt-get -y install gnupg2
      echo ""
    fi
  gpg --dearmor /root/aptkeys/grafana.key
  cp /root/aptkeys/grafana.key.gpg /etc/apt/keyrings/grafana.gpg

  echo ""
  echo "  Agregando repositorio..." 
  echo ""
  echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | tee -a /etc/apt/sources.list.d/grafana.list

  echo ""
  echo "  Instalando paquetes..." 
  echo ""
  apt-get update
  apt-get -y install grafana-enterprise

  # Preparar para https
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
     
  # Permitir embedded
     sed -i -e 's|;allow_embedding = false|allow_embedding = true|g'   /etc/grafana/grafana.ini
     sed -i -e 's|;cookie_samesite = lax|cookie_samesite = disabled|g' /etc/grafana/grafana.ini

  echo ""
  echo "  Activando el servicio..." 
  echo ""
  systemctl enable grafana-server --now

  echo ""
  echo "  Instalando el plugin grafana-image-renderer..." 
  echo ""
  grafana-cli plugins install grafana-image-renderer

  echo ""
  echo "  Reiniciando el servicio..." 
  echo ""
  systemctl restart grafana-server

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Grafana para Debian 11 (Bullseye)..."  
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
  # Para cuando apt-key quede obsoleto:
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

  # Preparar para https
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
     
  # Permitir embedded
     sed -i -e 's|;allow_embedding = false|allow_embedding = true|g'   /etc/grafana/grafana.ini
     sed -i -e 's|;cookie_samesite = lax|cookie_samesite = disabled|g' /etc/grafana/grafana.ini

  echo ""
  echo "  Activando el servicio..." 
  echo ""
  systemctl enable grafana-server --now

  echo ""
  echo "  Instalando el plugin grafana-image-renderer..." 
  echo ""
  grafana-cli plugins install grafana-image-renderer

  echo ""
  echo "  Reiniciando el servicio..." 
  echo ""
  systemctl restart grafana-server

elif [ $cVerSO == "10" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de Grafana para Debian 10 (Buster)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de Grafana para Debian 9 (Stretch)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Grafana para Debian 8 (Jessie)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Grafana para Debian 7 (Wheezy)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

fi

