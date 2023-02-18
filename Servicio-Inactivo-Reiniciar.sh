#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para comprobar si Apache2 está inactivo y reiniciarlo si lo está
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/Apache2-ReiniciarSiNoActivo.sh | bash
# ----------

vColorAzul="\033[0;34m"
vColorAzulClaro="\033[1;34m"
vColorVerde='\033[1;32m'
vColorRojo='\033[1;31m'
vFinColor='\033[0m'

vNombreDelServicio="$1"

vEstaCargado=$(systemctl status $vNombreDelServicio.service | grep "oaded:" | cut -d':' -f2 | sed 's- --g' | cut -d'(' -f1)
if [[ $vEstaCargado == "loaded" ]]; then
  echo ""
  echo -e "${vColorVerde}  El servicio $vNombreDelServicio está cargado.${vFinColor} Comprobando si está activo..."
  vEstaActivo=$(systemctl status $vNombreDelServicio.service | grep "ctive:" | cut -d':' -f2 | sed 's- --g' | cut -d'(' -f1)
  if [[ $vEstaActivo == "inactive" ]]; then
    echo ""
    echo -e "${vColorRojo}    El servicio $vNombreDelServicio está inactivo.${vFinColor} Intentando levantarlo..."
    echo ""
    systemctl restart $vNombreDelServicio.service
    systemctl status $vNombreDelServicio.service --no-pager
    echo ""
  elif [[ $vEstaActivo == "active" ]]; then
    echo ""
    echo -e "${vColorVerde}    El servicio $vNombreDelServicio está activo.${vFinColor} No se realizará ninguna acción."
    echo ""
  fi
else
  echo ""
  echo "  No parece que systemd haya cargado el servicio $vNombreDelServicio al inicio del sistema. No se puede determinar el estado."
  echo ""
fi

