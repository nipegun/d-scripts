#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para hacer copia de seguridad interna de los archivos importantes del sistema operativo
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/CopSegInt-ArchivosDelSO.sh | bash
#
# Ejecución remota sin caché:
#  curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/CopSegInt-ArchivosDelSO.sh | bash
# ----------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

vNombreDelServidor=$(cat /etc/hostname)
vPuntoMontPartCopSeg="/Particiones/CopSeg/"

# Determinar la fecha de ejecución del script
  vFechaDeEjec=$(date +A%YM%mD%d@%T)

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${ColorVerde}  Iniciando la copia de seguridad de los archivos del Sistema Operativo...${FinColor}"
  echo ""

# Encender la luz del Blink1
  #chmod +x /root/git/blink1-tool/blink1-tool
  #/root/git/blink1-tool/blink1-tool --red > /dev/null

# Montar disco de copias de seguridad
  #echo ""
  #echo -e "${ColorVerde}  Montando el disco de copias de seguridad...${FinColor}"
  #echo ""
  #umount /dev/disk/by-parlabel/PartCopSeg 2> /dev/null
  #mount -t auto -v /dev/disk/by-partlabel/CopSeg "$vPuntoMontPartCopSeg"

# Carpeta root
  echo ""
  echo -e "${ColorVerde}  Copia de seguridad de la carpeta root...${FinColor}"
  echo ""
  mkdir -p "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/root/
  #cp /root/* "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/root/
  mkdir -p "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/root/.local/share/mc/
  touch    "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/root/.local/share/mc/bashrc

  # .bashrc
    mkdir - p        "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$FechaDeEjec/root/
    cp /root/.bashrc "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$FechaDeEjec/root/

  # scripts
    mkdir -p "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/root/scripts/
    touch    "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/root/scripts/

  # mc
    mkdir -p                       "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/root/.config/mc/
    cp /root/.config/mc/panels.ini "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/root/.config/mc/

# Carpeta /etc
  echo ""
  echo -e "${ColorVerde}  Realizando copia de seguridad de los archivos de la carpeta /etc...${FinColor}"
  echo ""

  # default
    mkdir -p "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/etc/default/

    # grub
      cp /etc/default/grub "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/etc/default/

  # network
    mkdir -p                   "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/etc/network/
    cp /etc/network/interfaces "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/etc/network/

  # Reglas de renombrados de interfaces de red
    mkdir -p                                     "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/etc/udev/rules.d/
    cp /etc/udev/rules.d/70-persistent-net.rules "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/etc/udev/rules.d/

  # crontab
    mkdir -p        "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/etc/
    cp /etc/crontab "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/etc/

  # fstab
    cp /etc/fstab "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/etc/

  # resolv
    cp /etc/resolv.conf "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/etc/

  # sysctl
    cp /etc/sysctl.conf "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/etc/

# Desmontar el disco de copias de seguridad
  echo ""
  echo -e "${ColorVerde}  Desmontando el disco de copias de seguridad...${FinColor}"
  echo ""
  umount /dev/disk/by-partlabel/PartCopSeg

# Apagar la luz del Blink1
  #/root/git/blink1-tool/blink1-tool --off > /dev/null

# Loguear tarea
  echo "$vFechaDeEjec - Terminada la copia de seguridad del SO ProxmoxVE." >> /var/log/CopiasDeSeguridad.log

# Notificar fin de ejecución del script
  echo ""
  echo -e "${ColorVerde}  Ejecución del script, finalizada.${FinColor}"
  echo ""
