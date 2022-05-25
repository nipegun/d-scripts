#!/bin/bash

vIPWAN=111.111.111.111

vPuertoInicio=10100
vPuertoFin=15000

echo "  Escaneando puertos posibles ..."
nmap $vIPWAN -p $vPuertoInicio-$vPuertoFin10999 | grep ^1 | cut -d'/' -f1 > /tmp/puertos.txt

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

# sudo nmap -sV -O -sSU $vIPWAN -p 10300-10399

