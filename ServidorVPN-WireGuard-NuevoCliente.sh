#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------------
#  Script de NiPeGun para agregar un nuevo cliente al servidor WireGuard
#-------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

ClavePúblicaDelNuevoCliente IPDelCliente 

wg set wg0 peer <Client Public Key> endpoint <Client IP address>:51820 allowed-ips 203.0.113.12/24,fd86:ea04:1115::5/64
