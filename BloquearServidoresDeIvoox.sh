#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para bloquear los servidores de Ivoox
# ----------

cColorVerde="\033[1;32m"
cFinColor="\033[0m"

echo ""
echo -e "${cColorVerde}Bloqueando los servidores de Ivoox...${cFinColor}"
echo ""

# Obtener la IP de Ivoox.com
IPDeIvooxCom=$(getent hosts ivoox.com | awk '{ print $1 }')

# Agregar la IP obtenida al set creado anteriormente
iptables -A INPUT -s $IPDeIvooxCom -j DROP

# Crear un nuevo set para la lista de IPs a banear
ipset --flush IPsDeIvoox
ipset --create IPsDeIvoox iphash

# Agregar todas las posibles IPs de Ivoox al set (77.73.80.1 a 77.73.87.255)
ipset -q -A IPsDeIvoox 77.73.80.0/21 # -q silencia las advertencias para IPs previamente agregadas

# Agregar una regla INPUT a iptables con el set de IPs a banear
iptables -A INPUT -m set --match-set IPsDeIvoox src -j DROP

