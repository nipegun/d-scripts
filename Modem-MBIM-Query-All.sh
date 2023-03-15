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
#
#  Ejecución remota con parámetros:
#  curl -s x | bash -s Parámetro1 Parámetro2
# ----------

vColorAzul="\033[0;34m"
vColorAzulClaro="\033[1;34m"
vColorVerde='\033[1;32m'
vColorRojo='\033[1;31m'
vFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${vColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${vFinColor}" >&2
    exit 1
  fi

# Comprobar si el paquete mbimcli está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s mbimcli 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${vColorRojo}  mbimcli no está instalado. Iniciando su instalación...${vFinColor}"
    echo ""
    apt-get -y update
    apt-get -y install mbimcli
    echo ""
  fi

echo ""
echo "  Ejecutando query-device-caps..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-device-caps

echo ""
echo "  Ejecutando query-subscriber-ready-status..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-subscriber-ready-status

echo ""
echo "  Ejecutando query-radio-state..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-radio-state

echo ""
echo "  Ejecutando query-device-services..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-device-services

echo ""
echo "  Ejecutando query-pin-state..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-pin-state

echo ""
echo "  Ejecutando query-pin-list..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-pin-list

echo ""
echo "  Ejecutando query-home-provider..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-home-provider

echo ""
echo "  Ejecutando query-preferred-providers..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-preferred-providers

echo ""
echo "  Ejecutando query-visible-providers..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-visible-providers

echo ""
echo "  Ejecutando query-registration-state..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-registration-state

echo ""
echo "  Ejecutando query-signal-state..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-signal-state

echo ""
echo "  Ejecutando query-packet-service-state..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-packet-service-state

echo ""
echo "  Ejecutando query-packet-statistics..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-packet-statistics

echo ""
echo "  Ejecutando query-provisioned-contexts..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-provisioned-contexts

echo ""
echo "  Ejecutando query-network-idle-hint..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-network-idle-hint

echo ""
echo "  Ejecutando query-emergency-mode..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-emergency-mode

echo ""
echo "  Ejecutando phonebook-query-configuration..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --phonebook-query-configuration

echo ""
echo "  Ejecutando ms-query-firmware-id..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-firmware-id

echo ""
echo "  Ejecutando ms-query-sar-config..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-sar-config

echo ""
echo "  Ejecutando ms-query-transmission-status..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-transmission-status

echo ""
echo "  Ejecutando atds-query-signal..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --atds-query-signal

echo ""
echo "  Ejecutando atds-query-location..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --atds-query-location

echo ""
echo "  Ejecutando ms-query-lte-attach-configuration..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-lte-attach-configuration

echo ""
echo "  Ejecutando ms-query-lte-attach-info..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-lte-attach-info

echo ""
echo "  Ejecutando ms-query-sys-caps..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-sys-caps

echo ""
echo "  Ejecutando ms-query-device-caps..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-device-caps

echo ""
echo "  Ejecutando ms-query-device-slot-mappings..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-device-slot-mappings

echo ""
echo "  Ejecutando ms-query-location-info-status..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-location-info-status

echo ""
echo "  Ejecutando ms-query-provisioned-contexts..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-provisioned-contexts

echo ""
echo "  Ejecutando ms-query-base-stations-info..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-base-stations-info

echo ""
echo "  Ejecutando ms-query-registration-parameters..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-registration-parameters

echo ""
echo "  Ejecutando ms-query-modem-configuration..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-modem-configuration

echo ""
echo "  Ejecutando ms-query-wake-reason..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-wake-reason

echo ""
echo "  Ejecutando quectel-query-radio-state..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --quectel-query-radio-state

echo ""
echo "  Ejecutando intel-query-rfim..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --intel-query-rfim

echo ""
echo "  Ejecutando ms-query-nitz..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-nitz

echo ""
echo "  Ejecutando ms-query-uicc-application-list..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-uicc-application-list

echo ""
echo "  Ejecutando ms-query-uicc-atr..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-uicc-atr

echo ""
echo "  Ejecutando ms-query-uicc-reset..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-uicc-reset

echo ""
echo "  Ejecutando ms-query-uicc-terminal-capability..."
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-uicc-terminal-capability
