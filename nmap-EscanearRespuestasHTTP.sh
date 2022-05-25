#!/bin/bash

vIPWAN=111.111.111.111

vPuertoInicio=1
vPuertoFin=65535


sudo rm -f /tmp/puertos.txt 2> /dev/null

echo ""
echo "  Buscando puertos abiertos en la IP $vIPWAN que den respuesta http..."
echo ""
  sudo nmap $vIPWAN -p $vPuertoInicio-$vPuertoFin | grep '^[0-9]' | cut -d'/' -f1 > /tmp/puertos.txt
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
      sudo nmap -sV -O -sSU $vIPWAN -p $line >> /tmp/ServiciosDeLaIP-$vIPWAN.txt
    done

echo ""
echo "  Toda la información disponible sobre los servicios encontrados en la IP $vIPWAN"
echo "  se ha guardado en el archivo /tmp/ServiciosDeLaIP$vIPWAN.txt"
echo ""

