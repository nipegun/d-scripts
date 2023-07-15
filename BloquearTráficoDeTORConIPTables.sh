#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para bloquear paquetes entrantes provenientes de Tor
# ----------

echo ""
echo "Obteniendo la IP WAN del servidor..."
echo ""
IPWANDelServidor=$(curl --silent ipinfo.io/ip)

echo ""
echo "Creando un nuevo set para la lista de IPs a banear..."
echo ""
ipset --flush NodosTORQueEntran
ipset --create NodosTORQueEntran iphash

echo ""
echo "Obteniendo una lista de las IPs de los nodos Tor de salida que pueden acceder"
echo "a la IP del servidor y agregando esa lista al set creado antes..."
echo ""
# Abajo, se borran del wget resultante las líneas comentadas y se lee línea por línea las IPs
wget -q https://check.torproject.org/cgi-bin/TorBulkExitList.py?ip=$IPWANDelServidor -O -|sed '/^#/d' |while read IP
  do
    ipset -q -A NodosTORQueEntran $IP # -q silencia las advertencias para IPs previamente agregadas
  done

echo ""
echo "Agregando una regla input a IPTables con el set de IPs de nodos a banear..."
echo ""
iptables -A INPUT -m set --match-set NodosTORQueEntran src -j DROP

echo ""
echo "Ejecución del script finalizada."
echo ""

