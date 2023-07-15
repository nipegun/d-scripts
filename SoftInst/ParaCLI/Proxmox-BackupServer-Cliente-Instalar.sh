#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar el cliente de PBS (Proxmox BackUpServer) en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Proxmox-BackupServer-Cliente-Instalar.sh | bash
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Proxmox-BackupServer-Cliente-Instalar.sh | sed 's|192.168.1.9|192.168.1.10|g' | sed 's|pbsdt|pbsdatastorage|g' | bash
# ----------

vArch=amd64
vIPpbs="192.168.1.9"
vDataStorage="pbsdt"

cColorAzul="\033[0;34m"
cColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}" >&2
    exit 1
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

if [ $cVerSO == "7" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación del cliente de Proxmox Backup Server para Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación del cliente de Proxmox Backup Server para Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación del cliente de Proxmox Backup Server para Debian 9 (Stretch)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación del cliente de Proxmox Backup Server para Debian 10 (Buster)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación del cliente de Proxmox Backup Server para Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  echo ""
  echo "    Agregando el repositorio PBS Client..."
  echo ""
  vArch=amd64
  echo "deb [arch=$vArch] http://download.proxmox.com/debian/pbs-client bullseye main" > /etc/apt/sources.list.d/pbs-client.list
  # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  wget no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update
      apt-get -y install wget
      echo ""
    fi
  wget http://enterprise.proxmox.com/debian/proxmox-release-bullseye.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg
  apt-get -y update
  echo ""
  echo "    Instalando el paquete proxmox-backup-client..."
  echo ""
  apt-get -y install proxmox-backup-client
  echo ""
  echo "    Creando el script para copias de seguridad completas..."
  echo ""
  mkdir -p /root/scripts/EsteDebian/ 2> /dev/null
  echo "$vIPpbs:$vDataStorage" > /root/scripts/EsteDebian/RutaPBS.txt
  echo '#!/bin/bash'                                                                    > /root/scripts/EsteDebian/CopSeg-SistemaDeArchivosCompletoHaciaPBS.sh
  echo ''                                                                              >> /root/scripts/EsteDebian/CopSeg-SistemaDeArchivosCompletoHaciaPBS.sh
  echo "if [ -f /root/scripts/EsteDebian/RutaPBS.txt ]; then"                          >> /root/scripts/EsteDebian/CopSeg-SistemaDeArchivosCompletoHaciaPBS.sh
  echo '  vRuta=$(cat /root/scripts/EsteDebian/RutaPBS.txt)'                           >> /root/scripts/EsteDebian/CopSeg-SistemaDeArchivosCompletoHaciaPBS.sh
  echo '  proxmox-backup-client backup root.pxar:/ --repository $vRuta'                >> /root/scripts/EsteDebian/CopSeg-SistemaDeArchivosCompletoHaciaPBS.sh
  echo "else"                                                                          >> /root/scripts/EsteDebian/CopSeg-SistemaDeArchivosCompletoHaciaPBS.sh
  echo "  proxmox-backup-client backup root.pxar:/ --repository $vIPpbs:$vDataStorage" >> /root/scripts/EsteDebian/CopSeg-SistemaDeArchivosCompletoHaciaPBS.sh
  echo "fi"                                                                            >> /root/scripts/EsteDebian/CopSeg-SistemaDeArchivosCompletoHaciaPBS.sh
  chmod +x                                                                                /root/scripts/EsteDebian/CopSeg-SistemaDeArchivosCompletoHaciaPBS.sh

fi

