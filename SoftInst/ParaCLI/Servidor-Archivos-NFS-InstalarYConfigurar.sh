#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar el servidor Samba en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-Archivos-NFS-InstalarYConfigurar.sh
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then              # Para systemd y freedesktop.org
     . /etc/os-release
     cNomSO=$NAME
     cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then  # linuxbase.org
       cNomSO=$(lsb_release -si)
       cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then           # Para algunas versiones de Debian sin el comando lsb_release
       . /etc/lsb-release
       cNomSO=$DISTRIB_ID
       cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then        # Para versiones viejas de Debian.
       cNomSO=Debian
       cVerSO=$(cat /etc/debian_version)
  else                                         # Para el viejo uname (También funciona para BSD)
       cNomSO=$(uname -s)
       cVerSO=$(uname -r)
  fi

if [ $cVerSO == "7" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación del servidor NFS para Debian 7 (Wheezy)..."
  
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación del servidor NFS para Debian 8 (Jessie)..."
  
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación del servidor NFS para Debian 9 (Stretch)..."
  
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación del servidor NFS para Debian 10 (Buster)..."
  
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación del servidor NFS para Debian 11 (Bullseye)..."
  
  echo ""

  echo ""
  echo "  ATENCIÓN: Este script no es válido para instalaciones en contenedores LXC."
  echo "  Debe ser ejecutado en un baremetal o máquina virtual."
  echo ""
  echo "  Para instalaciones en LXC, buscar el script en los p-scripts."
  echo ""
  apt-get -y update
  apt-get -y install nfs-kernel-server
  apt-get -y install nfs-common         # lockd, statd, showmount, nfsstat, etc.
  apt-get -y install rpcbind            # convierte los identificadores de programa RPC (Remote Procedure Call) en direcciones universales ¿?
  mkdir -p /CarpetaNFS/
  chown nobody:nogroup /CarpetaNFS/
  chmod 777 /CarpetaNFS/
  cp /etc/exports /etc/exports.ori
  echo "/CarpetaNFS *(sync)" > /etc/exports                      # Montar sólo lectura
  #echo "/CarpetaNFS *(rw,sync,no_subtree_check)" > /etc/exports # Montar lectura y escritura
  #echo "/CarpetaNFS 192.168.1.80(rw,sync,no_subtree_check)" > /etc/exports # Montar lectura y escritura para un host específico
  exportfs -av
  systemctl restart nfs-kernel-server

fi
