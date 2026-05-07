#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar ChirpStack en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/LoRaWAN-ChirpStack-InstalarYConfigurar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/LoRaWAN-ChirpStack-InstalarYConfigurar.sh | sed 's-sudo--g' | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/LoRaWAN-ChirpStack-InstalarYConfigurar.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/LoRaWAN-ChirpStack-InstalarYConfigurar.sh | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/LoRaWAN-ChirpStack-InstalarYConfigurar.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
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

# Ejecutar comandos dependiendo de la versión de Debian detectada

  if [ $cVerSO == "13" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ChirpStack para Debian 13 (x)...${cFinColor}"
    echo ""

    # Actualizar la lista de paquetes disponibles en los repositorios
      sudo apt-get -y update
      sudo apt-get -y install gpg
      sudo apt-get -y install wget
      sudo apt-get -y install ca-certificates
      sudo apt-get -y install apt-transport-https

    # Añadir la clave
      sudo mkdir -p /etc/apt/keyrings
      wget -q -O - https://artifacts.chirpstack.io/packages/chirpstack.key | sudo gpg --dearmor > /etc/apt/keyrings/chirpstack.gpg

    # Añadir el repo
      sudo echo "deb [signed-by=/etc/apt/keyrings/chirpstack.gpg] https://artifacts.chirpstack.io/packages/4.x/deb stable main" > /etc/apt/sources.list.d/chirpstack.list
      sudo apt-get -y update

    # Instalar paquetes
      sudo apt-get -y install mosquitto
      sudo apt-get -y install mosquitto-clients
      sudo apt-get -y install redis-server
      sudo apt-get -y install redis-tools postgresql

    #
      if [ "$(id -u)" -eq 0 ]; then
        runuser -u postgres -- psql -d postgres -v ON_ERROR_STOP=1 \
          -c "create role chirpstack with login password 'chirpstack';" \
          -c "create database chirpstack with owner chirpstack;" && \
        runuser -u postgres -- psql -d chirpstack -v ON_ERROR_STOP=1 \
          -c "create extension pg_trgm;"
      else
        sudo -u postgres psql -d postgres -v ON_ERROR_STOP=1 \
          -c "create role chirpstack with login password 'chirpstack';" \
          -c "create database chirpstack with owner chirpstack;" && \
        sudo -u postgres psql -d chirpstack -v ON_ERROR_STOP=1 \
          -c "create extension pg_trgm;"
      fi

    # 
      sudo apt-get -y install chirpstack-gateway-bridge
      cp /etc/chirpstack-gateway-bridge/chirpstack-gateway-bridge.toml /etc/chirpstack-gateway-bridge/chirpstack-gateway-bridge.toml.bak
      sed -i 's/^type="semtech_udp"$/type="basic_station"/' /etc/chirpstack-gateway-bridge/chirpstack-gateway-bridge.toml

    #
      sudo apt-get -y install chirpstack
      vSecret="$(head -c 32 /dev/urandom | base64)"
      sudo sed -i "s|secret = \"you-must-replace-this\"|secret = \"$vSecret\"|" /etc/chirpstack/chirpstack.toml
      sudo systemctl restart postgresql redis-server mosquitto chirpstack chirpstack-gateway-bridge

    # Comprobar servicios
      sudo systemctl --no-pager --full status postgresql redis-server mosquitto chirpstack chirpstack-gateway-bridge
      sudo ss -lntp | grep -E ':8080|:3001|:1883|:5432|:6379'

    # 
      sed -i 's|event_topic_template="gateway/{{ .GatewayID }}/event/{{ .EventType }}"|event_topic_template="eu868/gateway/{{ .GatewayID }}/event/{{ .EventType }}"|' /etc/chirpstack-gateway-bridge/chirpstack-gateway-bridge.toml
      sed -i 's|command_topic_template="gateway/{{ .GatewayID }}/command/#"|command_topic_template="eu868/gateway/{{ .GatewayID }}/command/#"|' /etc/chirpstack-gateway-bridge/chirpstack-gateway-bridge.toml
      grep -nE 'event_topic_template|command_topic_template' /etc/chirpstack-gateway-bridge/chirpstack-gateway-bridge.toml
      systemctl restart chirpstack-gateway-bridge
      journalctl -u chirpstack-gateway-bridge -n 50 --no-pager

    # Credenciales iniciales admin:adin
      vIPLocal=$(hostname -I | sed 's- --g')
      echo ""
      echo "  En este punto la web debería estar disponible en: http://$vIPLocal:8080"
      echo ''
      echo '    La credencial por defecto es admin:admin'
      echo '    Para cambiarla, arriba a a la derecha: "admin" > "Change password"'
      echo ''
      echo '    Para crear el tenant:'
      echo '      "Network servers" > "Tenants" > "Add tenant"'
      echo '        Name: ElQueQuieras'
      echo '        Tenant can have gateways: activado'
      echo '        Gateways are private (uplink): desactivado'
      echo '        Gateways are private (downlink): desactivado'
      echo '        Max. gateway count: 10'
      echo '        Max. device count: 1000'
      echo ''
      echo '    Para agregar el gateway:'
      echo '      "Gateways" > "Add gateway"'
      echo '        Name: routerx'
      echo '        Description: Gateway LoRaWAN OpenWrt routerx'
      echo '        Gateway ID: xxxxxxxxxxxx (es la mac del station id de openwrt, toda junta, sin dos puntos)'
      echo '      Al terminar de agregar el gateway ya se puede configurar BasicStation en OpenWrt'

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ChirpStack para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 12 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ChirpStack para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ChirpStack para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ChirpStack para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ChirpStack para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ChirpStack para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
