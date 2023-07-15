#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para comprobar si Apache2 está inactivo y reiniciarlo si lo está
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Apache2-ReiniciarSiNoActivo.sh | bash
# ----------

cColorAzul="\033[0;34m"
cColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
cFinColor='\033[0m'

vNombreDelServicio="$1"

vEstaCargado=$(systemctl status $vNombreDelServicio.service | grep "oaded:" | cut -d':' -f2 | sed 's- --g' | cut -d'(' -f1)
if [[ $vEstaCargado == "loaded" ]]; then
  echo ""
  echo -e "${cColorVerde}  El servicio $vNombreDelServicio está cargado.${cFinColor} Comprobando si está activo..."
  vEstaActivo=$(systemctl status $vNombreDelServicio.service | grep "ctive:" | cut -d':' -f2 | sed 's- --g' | cut -d'(' -f1)
  if [[ $vEstaActivo == "inactive" ]]; then
    echo ""
    echo -e "${cColorRojo}    El servicio $vNombreDelServicio está inactivo.${cFinColor} Intentando levantarlo..."
    echo ""
    systemctl restart $vNombreDelServicio.service
    systemctl status $vNombreDelServicio.service --no-pager
    echo ""
  elif [[ $vEstaActivo == "active" ]]; then
    echo ""
    echo -e "${cColorVerde}    El servicio $vNombreDelServicio está activo.${cFinColor} No se realizará ninguna acción."
    echo ""
  fi
else
  echo ""
  echo "  No parece que systemd haya cargado el servicio $vNombreDelServicio al inicio del sistema. No se puede determinar el estado."
  echo ""
fi

