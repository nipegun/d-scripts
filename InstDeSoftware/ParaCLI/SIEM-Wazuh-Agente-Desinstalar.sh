#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para desinstalar wazuh-agent de Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/SIEM-Wazuh-Agente-Desinstalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/SIEM-Wazuh-Agente-Desinstalar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/SIEM-Wazuh-Agente-Desinstalar.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Reinciar wazuh-manager
  sudo systemctl stop wazuh-agent
  sudo systemctl disable wazuh-agent --now
# Parar todos los procesos
  sudo ps aux | grep -i wazuh | grep var | sed 's-  - -g'| sed 's-  - -g' | sed 's-  - -g' | cut -d' ' -f11 | cut -d'/' -f5 | xargs sudo killall -9
# Borrar paquete
  sudo apt-get -y autoremove --purge wazuh-agent
# Borrar carpetas
  sudo rm -rfv /var/ossec/
  sudo rm -fv /usr/share/lintian/overrides/wazuh-agent
  sudo rm -fv /usr/lib/systemd/system/wazuh-agent.service
  sudo rm -fv /etc/systemd/system/wazuh-agent.service
  sudo rm -fv /var/lib/dpkg/info/wazuh-agent.list
  sudo rm -fv /var/lib/dpkg/info/wazuh-agent.md5sums
  sudo rm -fv /var/lib/dpkg/info/wazuh-agent.prerm
  sudo rm -fv /var/lib/dpkg/info/wazuh-agent.postrm
  sudo rm -fv /var/lib/dpkg/info/wazuh-agent.postinst
  sudo rm -fv /var/lib/dpkg/info/wazuh-agent.shlibs
  sudo rm -fv /var/lib/dpkg/info/wazuh-agent.preinst
  sudo rm -fv /var/lib/dpkg/info/wazuh-agent.conffiles
  sudo rm -fv /var/lib/dpkg/info/wazuh-agent.templates
