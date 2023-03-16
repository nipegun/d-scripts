#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para obtener información del modem 4G mediante el protocolo MBIM
#
# Ejecución remota:
#   curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/Modem-MBIM-Query-All.sh | bash
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

# Comprobar si el paquete libmbim-utils está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s libmbim-utils 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${vColorRojo}  libmbim-utils no está instalado. Iniciando su instalación...${vFinColor}"
    echo ""
    apt-get -y update
    apt-get -y install libmbim-utils
    echo ""
  fi

echo ""
echo -e "${vColorAzulClaro}  Ejecutando query-device-caps...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-device-caps

echo ""
echo -e "${vColorAzulClaro}  Ejecutando query-subscriber-ready-status...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-subscriber-ready-status

echo ""
echo -e "${vColorAzulClaro}  Ejecutando query-radio-state...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-radio-state

echo ""
echo -e "${vColorAzulClaro}  Ejecutando query-device-services...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-device-services

echo ""
echo -e "${vColorAzulClaro}  Ejecutando query-pin-state...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-pin-state

echo ""
echo -e "${vColorAzulClaro}  Ejecutando query-pin-list...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-pin-list

echo ""
echo -e "${vColorAzulClaro}  Ejecutando query-home-provider...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-home-provider

echo ""
echo -e "${vColorAzulClaro}  Ejecutando query-preferred-providers...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-preferred-providers

echo ""
echo -e "${vColorAzulClaro}  Ejecutando query-visible-providers...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-visible-providers

echo ""
echo -e "${vColorAzulClaro}  Ejecutando query-registration-state...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-registration-state

echo ""
echo -e "${vColorAzulClaro}  Ejecutando query-signal-state...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-signal-state

echo ""
echo -e "${vColorAzulClaro}  Ejecutando query-packet-service-state...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-packet-service-state

echo ""
echo -e "${vColorAzulClaro}  Ejecutando query-packet-statistics...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-packet-statistics

echo ""
echo -e "${vColorAzulClaro}  Ejecutando query-provisioned-contexts...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-provisioned-contexts

echo ""
echo -e "${vColorAzulClaro}  Ejecutando query-network-idle-hint...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-network-idle-hint

echo ""
echo -e "${vColorAzulClaro}  Ejecutando query-emergency-mode...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-emergency-mode

echo ""
echo -e "${vColorAzulClaro}  Ejecutando phonebook-query-configuration...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --phonebook-query-configuration

echo ""
echo -e "${vColorAzulClaro}  Ejecutando ms-query-firmware-id...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-firmware-id

echo ""
echo -e "${vColorAzulClaro}  Ejecutando ms-query-sar-config...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-sar-config

echo ""
echo -e "${vColorAzulClaro}  Ejecutando ms-query-transmission-status...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-transmission-status

echo ""
echo -e "${vColorAzulClaro}  Ejecutando atds-query-signal...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --atds-query-signal

echo ""
echo -e "${vColorAzulClaro}  Ejecutando atds-query-location...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --atds-query-location

echo ""
echo -e "${vColorAzulClaro}  Ejecutando ms-query-lte-attach-configuration...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-lte-attach-configuration

echo ""
echo -e "${vColorAzulClaro}  Ejecutando ms-query-lte-attach-info...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-lte-attach-info

echo ""
echo -e "${vColorAzulClaro}  Ejecutando ms-query-sys-caps...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-sys-caps

echo ""
echo -e "${vColorAzulClaro}  Ejecutando ms-query-device-caps...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-device-caps

echo ""
echo -e "${vColorAzulClaro}  Ejecutando ms-query-device-slot-mappings...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-device-slot-mappings

echo ""
echo -e "${vColorAzulClaro}  Ejecutando ms-query-location-info-status...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-location-info-status

echo ""
echo -e "${vColorAzulClaro}  Ejecutando ms-query-provisioned-contexts...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-provisioned-contexts

echo ""
echo -e "${vColorAzulClaro}  Ejecutando ms-query-base-stations-info...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-base-stations-info

echo ""
echo -e "${vColorAzulClaro}  Ejecutando ms-query-registration-parameters...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-registration-parameters

echo ""
echo -e "${vColorAzulClaro}  Ejecutando ms-query-modem-configuration...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-modem-configuration

echo ""
echo -e "${vColorAzulClaro}  Ejecutando ms-query-wake-reason...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-wake-reason

echo ""
echo -e "${vColorAzulClaro}  Ejecutando quectel-query-radio-state...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --quectel-query-radio-state

echo ""
echo -e "${vColorAzulClaro}  Ejecutando intel-query-rfim...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --intel-query-rfim

echo ""
echo -e "${vColorAzulClaro}  Ejecutando ms-query-nitz...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-nitz

echo ""
echo -e "${vColorAzulClaro}  Ejecutando ms-query-uicc-application-list...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-uicc-application-list

echo ""
echo -e "${vColorAzulClaro}  Ejecutando ms-query-uicc-atr...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-uicc-atr

echo ""
echo -e "${vColorAzulClaro}  Ejecutando ms-query-uicc-reset...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-uicc-reset

echo ""
echo -e "${vColorAzulClaro}  Ejecutando ms-query-uicc-terminal-capability...${vFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-uicc-terminal-capability

