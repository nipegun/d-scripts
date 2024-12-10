#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar Promtail en Debian
#
# Ejecución remota
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Promtail-InstalarYConfigurar.sh | bash
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
  echo "  Iniciando el script de instalación de Promtail para Debian 13 (x)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 13 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "12" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Promtail para Debian 12 (Bullseye)..."  
  echo ""

  # Actualizar la lista de paquetes disponibles en los repositorios
    apt-get -y update

  # Determinar la última versión de loki
    echo ""
    echo "    Determinando la última versión de Loki disponible en github"
    echo ""
    # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${cColorRojo}      El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
        echo ""
        apt-get -y update
        apt-get -y install curl
        echo ""
      fi
    vUltVersLokiGitHub=$(curl -sL https://github.com/grafana/loki/releases/latest/ | grep -oP 'href="/grafana/loki/releases/tag/\K[^"]+' | head -n1 | cut -d'v' -f2)
    echo "  La última versión es la $vUltVersLokiGitHub"
    echo ""

  # Descargar el paquete con la última versión
    echo ""
    echo "    Descargando el paquete con la última versión..."
    echo ""
    mkdir -p /root/SoftInst/Loki/
    curl -L https://github.com/grafana/loki/releases/download/v$vUltVersLokiGitHub/loki-linux-amd64.zip -o /root/SoftInst/Loki/loki.zip

  # Descomprimir el paquete
    echo ""
    echo "    Descomprimiendo el paquete..."
    echo ""
    cd /root/SoftInst/Loki/
    # Comprobar si el paquete unzip está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s unzip 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${cColorRojo}      El paquete unzip no está instalado. Iniciando su instalación...${cFinColor}"
        echo ""
        apt-get -y update
        apt-get -y install unzip
        echo ""
      fi
    unzip loki.zip

  # Copiar el binario a /bin/
    echo ""
    echo "  Copiando el binario a /usr/bin"
    echo ""
    cp -fv /root/SoftInst/Loki/loki-linux-amd64 /usr/bin/

  # Crear el usuario sin privilegios para utilizar loki
    useradd --no-create-home --shell /bin/false loki
    mkdir -p /etc/loki
    chown -R loki:loki /etc/loki
    mkdir -p /var/lib/loki
    chown -R loki:loki /var/lib/loki

  # Crear el archivo de configuración
    echo ""
    echo "    Creando el archivo de configuración..."
    echo ""
    curl -L https://raw.githubusercontent.com/grafana/loki/refs/heads/main/cmd/loki/loki-local-config.yaml -o /etc/loki/loki-config.yaml
    cp /etc/loki/loki-config.yaml /etc/loki/loki-config.yaml.bak.ori
    # Reemplazar la IP de localhost por la IP privada del debian
      vIPLocal=$(hostname -I | cut -d' ' -f1 | tr -d '[:space:]')
      sed -i -e "s|127.0.0.1|$vIPLocal|g" /etc/loki/loki-config.yaml
    # Reparar permisos
      chown -R loki:loki /etc/loki

  # Crear el servicio de systemd
    echo "[Unit]"                                                                        > /etc/systemd/system/loki.service
    echo "Description=Loki Service"                                                     >> /etc/systemd/system/loki.service
    echo "After=network.target"                                                         >> /etc/systemd/system/loki.service
    echo ""                                                                             >> /etc/systemd/system/loki.service
    echo "[Service]"                                                                    >> /etc/systemd/system/loki.service
    echo "Type=simple"                                                                  >> /etc/systemd/system/loki.service
    echo "ExecStart=/usr/bin/loki-linux-amd64 --config.file=/etc/loki/loki-config.yaml" >> /etc/systemd/system/loki.service
    echo "Restart=always"                                                               >> /etc/systemd/system/loki.service
    echo "RestartSec=5"                                                                 >> /etc/systemd/system/loki.service
    echo "User=loki"                                                                    >> /etc/systemd/system/loki.service
    echo "Group=loki"                                                                   >> /etc/systemd/system/loki.service
    echo ""                                                                             >> /etc/systemd/system/loki.service
    echo "[Install]"                                                                    >> /etc/systemd/system/loki.service
    echo "WantedBy=multi-user.target"                                                   >> /etc/systemd/system/loki.service

  # Recargar los daemons
    systemctl daemon-reload

  # Habilitar e iniciar loki
    systemctl enable loki --now

  # Comprobar estado
    systemctl status loki.service --no-pager

  # Notificar fin de ejecución del script
    echo ""
    echo "    La ejecución de Loki ha finalizado."
    echo ""
    echo "    Recuerda instalar el forwarder promtail en cada máquina que enviará logs al servidor loki"
    echo "    Puedes instalarlo en cada servidor Linux con:"
    echo "      curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Promtail-InstalarYConfigurar.sh | bash"
    echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Promtail para Debian 11 (Bullseye)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 11 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de Promtail para Debian 10 (Buster)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de Promtail para Debian 9 (Stretch)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Promtail para Debian 8 (Jessie)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Promtail para Debian 7 (Wheezy)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

fi
