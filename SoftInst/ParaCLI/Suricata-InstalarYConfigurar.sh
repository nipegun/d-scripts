#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar y configurar suricata en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Suricata-InstalarYConfigurar.sh | bash
#
#  Ejecución remota sin caché:
#  curl -s -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Suricata-InstalarYConfigurar.sh | bash
#
#  Ejecución remota con parámetros:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Suricata-InstalarYConfigurar.sh | bash -s Parámetro1 Parámetro2
# ----------

vColorAzul="\033[0;34m"
vColorAzulClaro="\033[1;34m"
vColorVerde='\033[1;32m'
vColorRojo='\033[1;31m'
vFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${vColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${vFinColor}" >&2
    exit 1
  fi

# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${vColorRojo}  curl no está instalado. Iniciando su instalación...${vFinColor}"
    echo ""
    apt-get -y update
    apt-get -y install curl
    echo ""
  fi

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    OS_NAME=$NAME
    OS_VERS=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    OS_NAME=$(lsb_release -si)
    OS_VERS=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    OS_NAME=$DISTRIB_ID
    OS_VERS=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    OS_NAME=Debian
    OS_VERS=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    OS_NAME=$(uname -s)
    OS_VERS=$(uname -r)
  fi

if [ $OS_VERS == "7" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación y configuración de suricata para Debian 7 (Wheezy)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación y configuración de suricata para Debian 8 (Jessie)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación y configuración de suricata para Debian 9 (Stretch)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación y configuración de suricata para Debian 10 (Buster)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación y configuración de suricata para Debian 11 (Bullseye)...${vFinColor}"
  echo ""

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${vColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${vFinColor}"
      echo ""
      apt-get -y update
      apt-get -y install dialog
      echo ""
    fi

  menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
    opciones=(
      1 "Instalar paquete Suricata, dependencias y otros paquetes útiles." oon
      2 "Configurar para un Debian con una única interfaz de red." off
      3 "Configurar para un Debian en modo router (con, al menos, dos interfaces de red)." off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "  Instalando paquete Suricata, dependencias y otros paquetes útiles..."
            echo ""

            # Actualizar el sistema
              apt-get -y update
            # Instalar suricata
              apt-get -y install suricata
            # Instalar paquetes extra
              apt-get -y install jq

          ;;

          2)

            echo ""
            echo "  Configurando para un Debian con una única interfaz de red..."
            echo ""

            # Determinar las interfaces activas que tienen asignada una IP
              aInterfacesActivasConIP=($(/root/scripts/d-scripts/Red-Interfaces-Activas-ConIPAsignada.sh | grep "→" | cut -d ':' -f2))
            # Comprobar si efectivamente hay una única interfaz de red
              if [ $(echo ${#aInterfacesActivasConIP[@]}) == "1" ]; then
                echo ""
                echo "  Se ha encontrado una única interfaz activa con IP asignada: ${aInterfacesActivasConIP[0]}"
                echo "  Se configurará como interfaz por defecto."
                echo ""
                # Detener el servicio
                  echo ""
                  echo "  Deteniendo el servicio suricata..."
                  echo ""
                  systemctl stop suricata
                # Configurar
                  echo ""
                  echo "  Configurando suricata..."
                  echo ""
                  # Indicar la interfaz sobre la que va a correr
                    # Buscar una línea que empiece por "af-packet:" y ejecutar el reemplazo en la siguiente línea
                      # Reemplazar sólo texto coincidente de la siguiente línea
                        #sed -i "/^af-packet:/{ n; s|- interface: eth0|- interface: ${aInterfacesActivasConIP[0]}|g }" /etc/suricata/suricata.yaml
                      # Reemplazar toda la siguiente línea
                        sed -i "/^af-packet:/{ n; s|- interface:.*|- interface: ${aInterfacesActivasConIP[0]}|g }" /etc/suricata/suricata.yaml
                  # Indicar las redes que van a ser consideradas como home
                    # Detectar si la WAN es una IP privada o una Pública
                      vIPWAN="priv"
                      if [ $vIPWAN == "pub"  ]; then
                        sed -i -e 's|HOME_NET: "\[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12]"|#HOME_NET: "\[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12]"|g' /etc/suricata/suricata.yaml
                        sed -i -e 's|#HOME_NET: "\[192.168.0.0/16]"|HOME_NET: "\[192.168.0.0/16]"|g'                                                   /etc/suricata/suricata.yaml
                      elif [ $vIPWAN == "priv"  ]; then
                        vSubRedHomeNet="192.168.0.0/16"
                        sed -i -e 's|HOME_NET: "\[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12]"|#HOME_NET: "\[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12]"|g' /etc/suricata/suricata.yaml
                        sed -i -e 's|#HOME_NET: "\[192.168.0.0/16]"|HOME_NET: "\[$vSubRedHomeNet]"|g'                                                  /etc/suricata/suricata.yaml
                      fi
                # Iniciar el servicio
                  echo ""
                  echo "  Iniciando el servicio suricata..."
                  echo ""
                  systemctl start suricata
              elif [ $(echo ${#aInterfacesActivasConIP[@]}) == "" ]; then
                echo ""
                echo "  No se ha encontrado al menos una interfaz de red activa con IP asignada."
                echo "  No se configurará automáticmante la interfaz por defecto."
                echo "  Deberás configurarla manualmente editando el archivo /etc/suricata/suricata.yaml y cambiando"
                echo "    - interface: eth0"
                echo "  ...por la interfaz sobre la que quieres hacer correr suricata."
                echo ""
              else
                echo ""
                echo "  Se ha encontrad más de una interfaz red activa con IP asignada"
                echo "  No se configurará automáticmante la interfaz por defecto."
                echo "  Probablemente te interese volver a ejecutar el script y seleccionar la configuración"
                echo "  para Debian con más de una interfaz."
                echo ""
              fi

          ;;

          3)

            echo ""
            echo "  Configurando para un Debian en modo router (con, al menos, dos interfaces de red)."
            echo ""

          ;;


      esac

  done
 
fi

