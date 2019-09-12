#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------
#  SCRIPT DE NIPEGUN PARA DETENER TODOS LOS SERVICIOS DE PROXMOXVE
#  PARA, POR EJEMPLO, HACER CAMBIOS MANUALES EN LOS ARCHIVOS DE
#  CONFIGURACIÓN
#-------------------------------------------------------------------

echo ""
echo "------------------------------------------------"
echo "  Deteniendo todos los servicios de Proxmox..."
echo "------------------------------------------------"
echo ""

service pve-cluster stop
service pve-ha-crm stop
service pve-ha-lrm stop
service pvedaemon stop
service pveproxy stop
service pvestatd stop
service pve-firewall stop
service pvefw-logger stop

service pve-manager stop

