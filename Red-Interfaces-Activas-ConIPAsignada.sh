#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para determinar que interfaces de red activas tiene asignada una IP en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/Red-Interfaces-Activas-ConIPAsignada.sh | bash
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
  echo -e "${vColorAzulClaro}  Determinando que interfaces activas tienen una IP asignada en Debian 7 (Wheezy)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Determinando que interfaces activas tienen una IP asignada en Debian 8 (Jessie)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Determinando que interfaces activas tienen una IP asignada en Debian 9 (Stretch)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Determinando que interfaces activas tienen una IP asignada en Debian 10 (Buster)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Determinando que interfaces activas tienen una IP asignada en Debian 11 (Bullseye)...${vFinColor}"
  echo ""

  # Obtener las interfaces activas
    # Quitar todas las de proxmox
      #aIntRedActivas=($(ip link | grep "ate UP" | grep -v ^[^0-9] | grep -v lo | grep -v vir | grep -v wl | grep -v veth | grep -v fwbr | cut -d ':' -f2 | sed 's- --g'))
    # No incluir la loopback
      #aIntRedActivas=($(ip link | grep -v ^[^0-9] | cut -d ':' -f2 | sed 's- --g'))
    aIntRedActivas=($(ip link | grep "ate UP" | grep -v ^[^0-9] | cut -d ':' -f2 | sed 's- --g'))
  # Mostrar las interfaces activas (todos los valores del array)
    # Contar cuantas interfaces hay en el array
      vCantIntActivas=$(echo ${#aIntRedActivas[@]})
    # Mostrar las interfaces activas en una única línea
      #echo "  El sistema tiene $vCantIntActivas interfaz/faces activa/s: ${aIntRedActivas[@]}"
    # Mostrar en una única línea
      echo ""
      echo "  El sistema tiene $vCantIntActivas interfaz/faces activa/s:"
      echo ""
      for i in "${aIntRedActivas[@]}"
        do
          echo "    $i"
        done
      echo ""
  # De las interfaces activas, determinar cual tiene asignada una IP y guardar la info en otro array
    echo ""
    echo "  De esas $vCantIntActivas interfaz/faces activa/s, la siguientes interfaces tienen asignada una IP:"
    echo ""
    aInterfazActivaConIP=()
    for (( j=0; j<$vCantIntActivas; j++ ));
      do
        vInterfaz=$(echo "${aIntRedActivas[$j]}" | cut -d '@' -f1)
        vIPInt=$(ip a show $vInterfaz | grep "scope" | grep -Po '(?<=inet )[\d.]+')
        if [ "$vIPInt" != ""  ]; then
          echo "    → :$vInterfaz:$vIPInt"
          aInterfazActivaConIP[$j]=${aIntRedActivas[$j]}
        fi
      done
    echo ""
  # Seguir trabajando con el array aInterfazActivaConIP[@]

fi
