#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar y configurar xxxxxxxxx en Debian
#
#  Ejecución remota:
#  curl -s x | bash
#
#  Ejecución remota sin caché:
#  curl -s -H 'Cache-Control: no-cache, no-store' x | bash
# ----------

vColorAzul="\033[0;34m"
vColorAzulClaro="\033[1;34m"
vColorVerde='\033[1;32m'
vColorRojo='\033[1;31m'
vFinColor='\033[0m'

# Definir los octetos finales a recorrer.
for vSubRed in {0..5}
  do
    for vIPHost in {1..254}
      do
        # Determinar IP
          vIP="192.168.$vSubRed.$vIPHost"
        # Crear carpeta (por si no existe)
          mkdir -p /CopSeg/$vIP 2> /dev/null
        # Determinar si el host está activo
          # Comprobar si el paquete nmap está instalado. Si no lo está, instalarlo.
            if [[ $(dpkg-query -s nmap 2>/dev/null | grep installed) == "" ]]; then
              echo ""
              echo -e "${vColorRojo}  nmap no está instalado. Iniciando su instalación...${vFinColor}"
              echo ""
              apt-get -y update
              apt-get -y install nmap
              echo ""
            fi
          echo "Comprobando el host $vIP"
          if [[ $(nmap $vIP -p ssh | grep open | cut -d' ' -f2) == "open" ]]; then
            # Ejecutar sincronización
              echo ""
              echo "  $vIP está disponible,  -- EJECUTANDO COPIA --- ..."
              echo ""
              rsync --remove-source-files -a root@$vIP:/CopSegInt/ /CopSeg/$vIP
          else
             echo ""
             echo "  $vIP no está disponible, saltando..."
             echo ""
          fi
      done
  done
# Borrar las carpetas vacias
  find /CopSeg/ -empty -type d -delete
