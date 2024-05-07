#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para hacer copia de seguridad interna de servicios instalados en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/CopSegInt-Servicios.sh | bash
#
# Ejecución remota sin caché:
#  curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/CopSegInt-Servicios.sh | bash
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
  echo -e "${ColorVerde}  Iniciando la copia de seguridad del los archivos de ProxmoxVE...${FinColor}"
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

# Compartición Samba
  mkdir -p               "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/etc/samba/
  cp /etc/samba/smb.conf "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/etc/samba/

# Transmission
  mkdir -p                                  "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/etc/transmission-daemon/
  cp /etc/transmission-daemon/settings.json "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/etc/transmission-daemon/

# HostAPD
  cp /etc/default/hostapd      "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/etc/default/
  mkdir -p                     "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/etc/hostapd/
  cp /etc/hostapd/hostapd.conf "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/etc/hostapd/

# HAProxy
  mkdir -p                    "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/etc/haproxy/
  cp /etc/haproxy/haproxy.cfg "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/etc/haproxy/

# DDClient
  cp /etc/default/ddclient "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/etc/default/
  cp /etc/ddclient.conf    "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/etc/

# DHCP
  cp /etc/default/isc-dhcp-server "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/etc/default/
  mkdir -p                        "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/etc/dhcp/
  cp /etc/dhcp/dhcpd.conf         "$vPuntoMontPartCopSeg"ProxmoxVE/SO/"$vNombreDelServidor"/$vFechaDeEjec/etc/dhcp/

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
