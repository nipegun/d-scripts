#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para OBTENER LA LISTA DE IPS DE NODOS TOR
#  QUE LLEGAN A LA IP WAN Y GENERAR UNA ARCHIVO CON LA LISTA
# ----------

# Obtener la IP WAN del servidor y agregarla a una variable
IPWANDelServidor=$(curl --silent ipinfo.io/ip)

# Disminuir a cero el tamaño del archivo .list
truncate -s 0 /root/NodosTORQueEntran.list

echo ""
echo "  CREANDO EL ARCHIVO CON LA LISTA DE IPS DE LOS NODOS..."
echo ""
# Obtener la lista de nodos de salida que llegan al servidor, quitar las lineas comentadas de esa lista
# y recorrerla en busca de IPs para agregarlas también línea a línea en el archivo de texto.
wget -q https://check.torproject.org/cgi-bin/TorBulkExitList.py?ip=$IPWANDelServidor -O -| sed '/^#/d' | while read IP
  do
    echo "$IP" >> /root/NodosTORQueEntran.list
  done

echo ""
echo "  ARCHIVO: /root/NodosTORQueEntran.list CREADO"
echo ""
echo "  DENTRO ENCONTRARÁS LAS IPS DE LOS NODOS"
echo ""

