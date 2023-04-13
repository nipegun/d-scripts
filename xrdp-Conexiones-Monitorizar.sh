#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para monitorizar las conexiones xrdp
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/xrdp-Conexiones-Monitorizar.sh | bash
# ----------

# Crear el archivo de log, en caso de que no exista
  if [ ! -f /var/log/XRDPWatcher.log ]; then
    echo ""
    echo "  El archivo de log no existe, creando uno nuevo..."
    echo ""
    touch /var/log/XRDPWatcher.log
  fi

# Monitorizar las conexiones
  echo ""
  echo "  Monitorizando las conexiones xrdp..."
  echo ""
  tail -f /var/log/xrdp.log | grep --line-buffered -E "onnected client"\|"onnection established" | while read line
    do
      # Eliminar los brackets
        LineaGrep1=$(echo "${line}" | sed 's-[][]--g')
      # Borrar INFO
        LineaGrep2=$(echo "$LineaGrep1" | sed 's/INFO /-/g')
      # Reemplazar texto
        LineaGrep3=$(echo "$LineaGrep2" | sed 's-connected client computer name-New hostname trying to connect through xrdp-g')
      # Mostrar línea en consola y enviar también al log 
        echo "$LineaGrep3" | tee -a /var/log/XRDPWatcher.log
      # Preparar cadena para notificar por Telegram
        TextoAEnviar=$(echo "$LineaGrep3")
      # Notificar por Telegram
        /root/scripts/xrdp-NotificarCon.sh "$TextoAEnviar"
    done

