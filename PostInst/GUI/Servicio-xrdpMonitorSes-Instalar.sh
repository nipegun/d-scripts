#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Servicio de NiPeGun para monitorizar las sesiones xrdp
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/GUI/Servicio-xrdpMonitorSes-Instalar.sh | bash
# ----------

cColorAzul="\033[0;34m"
cColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
cFinColor='\033[0m'

echo ""
echo -e "${vColorAzulClaro}  Iniciando el script de instalación de la monitorización de sesiones concedidas al servidor xrdp...${cFinColor}"
echo ""

# Crear el servicio
  echo "[Unit]"                                                                    > /etc/systemd/system/xrdpMonitorSes.service
  echo "Description=Monitor de sesiones xrdp"                                     >> /etc/systemd/system/xrdpMonitorSes.service
  echo "After=network.target"                                                     >> /etc/systemd/system/xrdpMonitorSes.service
  echo ""                                                                         >> /etc/systemd/system/xrdpMonitorSes.service
  echo "[Service]"                                                                >> /etc/systemd/system/xrdpMonitorSes.service
  echo "Type=simple"                                                              >> /etc/systemd/system/xrdpMonitorSes.service
  echo "ExecStart=/bin/bash /root/scripts/d-scripts/xrdp-Sesiones-Monitorizar.sh" >> /etc/systemd/system/xrdpMonitorSes.service
  echo "TimeoutStartSec=0"                                                        >> /etc/systemd/system/xrdpMonitorSes.service
  echo "StartLimitInterval=0"                                                     >> /etc/systemd/system/xrdpMonitorSes.service
  echo "Restart=always"                                                           >> /etc/systemd/system/xrdpMonitorSes.service
  echo ""                                                                         >> /etc/systemd/system/xrdpMonitorSes.service
  echo "[Install]"                                                                >> /etc/systemd/system/xrdpMonitorSes.service
  echo "WantedBy=default.target"                                                  >> /etc/systemd/system/xrdpMonitorSes.service

# Recargar cambios
  systemctl daemon-reload

# Activar e iniciar el servicio
  systemctl enable xrdpMonitorSes.service --now

