#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para escanear todos los puertos abiertos de una IP que respondan a una solicitud HTTP
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/nmap-EscanearPuertosAbiertosConRespuestaHTTP.sh | bash
# ----------

vIPWAN=111.111.111.111

vPuertoInicio=1
vPuertoFin=65535

rm -f /tmp/puertos.txt 2> /dev/null

echo ""
echo "  Buscando puertos abiertos en la IP $vIPWAN que den respuesta http..."
echo ""
  nmap $vIPWAN -p $vPuertoInicio-$vPuertoFin | grep '^[0-9]' | cut -d'/' -f1 > /tmp/puertos.txt
  for line in $(cat /tmp/puertos.txt)
    do
      vRespuestaHTTP=$(curl -H 'Cache-Control: no-cache, no-store' --silent --max-time 10 -s -o /dev/null -w "%{http_code}" "http://$vIPWAN:$line")
      if [ $vRespuestaHTTP != "000" ]; then
        echo  "  Escaneando  http://$vIPWAN:$line - " $(curl --silent --max-time 10 "http://$vIPWAN:$line" | grep "itle>" | grep -o -P '(?<=<title>).*(?=</title>)')
      fi
      vRespuestaHTTPS=$(curl -H 'Cache-Control: no-cache, no-store' --silent --max-time 10 --insecure -s -o /dev/null -w "%{http_code}" "https://$vIPWAN:$line")
      if [ $vRespuestaHTTPS != "000" ]; then
        echo  "  Escaneando https://$vIPWAN:$line - " $(curl --silent --max-time 10 --insecure "https://$vIPWAN:$line" | grep "itle>" | grep -o -P '(?<=<title>).*(?=</title>)' )
      fi
    done

echo ""
echo "  Intentando encontrar el software que brinda servicio en esos puertos..."
echo ""
  rm -f /tmp/ServiciosDeLaIP-$vIPWAN.txt 2> /dev/null
  touch /tmp/ServiciosDeLaIP-$vIPWAN.txt 2> /dev/null
  for line in $(cat /tmp/puertos.txt)
    do
      nmap -sV -O -sSU $vIPWAN -p $line >> /tmp/ServiciosDeLaIP-$vIPWAN.txt
    done

echo ""
echo "  Toda la información disponible sobre los servicios encontrados en la IP $vIPWAN"
echo "  se ha guardado en el archivo /tmp/ServiciosDeLaIP$vIPWAN.txt"
echo ""

