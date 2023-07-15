#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

----
# Script de NiPeGun para instalar y configurar la compartición NFS en Debian
#
# Ejecución remota:
#  curl -sL bash https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-NFS-InstalarYConfigurar.sh | bash
----

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

  # Instalar el paquete necesario
    echo ""
    
    echo "  INSTALANDO EL PAQUETE NECESARIO PARA COMPARTIR POR NFS"
    
    echo ""
    apt-get -y install nfs-kernel-server

  # Crear el directorio a compartir
    echo ""
    echo "----------------------------------"
    echo "  CREANDO LA CARPETA A COMPARTIR"
    echo "----------------------------------"
    echo ""
    mkdir /nfs

  # Agregar un archivo a ese directorio para ver si la comparticón es correcta
    echo ""
    echo "----------------------------------------------------------------------------"
    echo "  AGREGANDO UN ARCHIVO A LA CARPETA COMPARTIDA PARA PROBAR LA COMPARTICIÓN"
    echo "----------------------------------------------------------------------------"
    echo ""
    echo "Prueba" > /nfs/Prueba.txt

  # Agregar la compartición a /etc/exports
    echo ""
    echo "--------------------------------------------------"
    echo "  AGREGANDO LA CARPETA COMPARTIDA A /etc/exports"
    echo "--------------------------------------------------"
    echo ""
    echo "/nfs *(rw,sync,no_subtree_check,no_root_squash)" >> /etc/exports

  # Aplicar cambios
    echo ""
    echo "--------------------------------------------------------"
    echo "  APLICANDO LOS CAMBIOS Y ACTIVANDO LAS COMPARTICIONES"
    echo "--------------------------------------------------------"
    echo ""
    exportfs -a

  # Activar el servicio para que la compartición esté disponible al inicio  del sistema
    echo ""
    echo "  ACTIVANDO EL SERVICIO PARA QUE ESTé DISPONIBLE AL INICIAR EL SISTEMA"
    echo ""
    systemctl enable nfs-kernel-server

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

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 11 (Bullseye)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

fi

