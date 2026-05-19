#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para hacer copia de seguridad interna de Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/CopSegInt.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/CopSegInt.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/CopSegInt.sh | nano -
# ----------

# Definir el archivo que contiene los datos a copiar
  cArchivoConDatosACopiar='/root/DataToBackup.txt'

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Definir el momento de ejecución del script
  cFechaDeEjec=$(date +a%Ym%md%dh%Hm%Ms%S)

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${cColorAzulClaro}  Iniciando la copia de seguridad interna el $cFechaDeEjec...${FinColor}"
  echo ""

# Crear la carpeta de copia de seguridad
  sudo mkdir -p /CopSegInt/"$cFechaDeEjec"/

# Loguear tarea
  echo "$cFechaDeEjec - Terminada la copia de seguridad interna." >> /var/log/CopiasDeSeguridad.log

# Notificar fin de ejecución del script
  echo ""
  echo -e "${ColorVerde}  Ejecución del script, finalizada.${FinColor}"
  echo ""
