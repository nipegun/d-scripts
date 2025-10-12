#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para borrar todos los logs de un servidor Wazuh
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/Wazuh-Server-Eventos-BorrarTodos.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/Wazuh-Server-Eventos-BorrarTodos.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/Wazuh-Server-Eventos-BorrarTodos.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script para borrar todos los agentes agregados al servidor Wazuh...${cFinColor}"
  echo ""

# Parar el servicio
  echo ""
  echo "    Parando el servicio wazuh-manager"
  echo ""
  sudo systemctl stop wazuh-manager



# Borrar todos los eventos de todos los agneetes
  echo ""
  echo "    Borrando los archivos que almacenan los agentes..."
  echo ""
  sudo rm -rfv /var/ossec/logs/alerts/*
  sudo rm -rfv /var/ossec/logs/archives/*

# Iniciar el servicio nuevamente
  echo ""
  echo "    Volviendo a iniciar el servicio..."
  echo ""
  sudo systemctl start wazuh-manager
