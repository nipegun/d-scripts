#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para obtener información del modem 4G mediante el protocolo MBIM
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Modem-MBIM-Query-All.sh | bash
# ----------

cColorAzul="\033[0;34m"
cColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    exit
  fi

# Comprobar si el paquete libmbim-utils está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s libmbim-utils 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}  libmbim-utils no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    apt-get -y update
    apt-get -y install libmbim-utils
    echo ""
  fi

echo ""
echo -e "${cColorAzulClaro}  Ejecutando query-device-caps...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-device-caps

echo ""
echo -e "${cColorAzulClaro}  Ejecutando query-subscriber-ready-status...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-subscriber-ready-status

echo ""
echo -e "${cColorAzulClaro}  Ejecutando query-radio-state...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-radio-state

echo ""
echo -e "${cColorAzulClaro}  Ejecutando query-device-services...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-device-services

echo ""
echo -e "${cColorAzulClaro}  Ejecutando query-pin-state...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-pin-state

echo ""
echo -e "${cColorAzulClaro}  Ejecutando query-pin-list...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-pin-list

echo ""
echo -e "${cColorAzulClaro}  Ejecutando query-home-provider...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-home-provider

echo ""
echo -e "${cColorAzulClaro}  Ejecutando query-preferred-providers...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-preferred-providers

echo ""
echo -e "${cColorAzulClaro}  Ejecutando query-visible-providers...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-visible-providers

echo ""
echo -e "${cColorAzulClaro}  Ejecutando query-registration-state...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-registration-state

echo ""
echo -e "${cColorAzulClaro}  Ejecutando query-signal-state...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-signal-state

echo ""
echo -e "${cColorAzulClaro}  Ejecutando query-packet-service-state...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-packet-service-state

echo ""
echo -e "${cColorAzulClaro}  Ejecutando query-packet-statistics...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-packet-statistics

echo ""
echo -e "${cColorAzulClaro}  Ejecutando query-provisioned-contexts...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-provisioned-contexts

echo ""
echo -e "${cColorAzulClaro}  Ejecutando query-network-idle-hint...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-network-idle-hint

echo ""
echo -e "${cColorAzulClaro}  Ejecutando query-emergency-mode...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --query-emergency-mode

echo ""
echo -e "${cColorAzulClaro}  Ejecutando phonebook-query-configuration...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --phonebook-query-configuration

echo ""
echo -e "${cColorAzulClaro}  Ejecutando ms-query-firmware-id...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-firmware-id

echo ""
echo -e "${cColorAzulClaro}  Ejecutando ms-query-sar-config...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-sar-config

echo ""
echo -e "${cColorAzulClaro}  Ejecutando ms-query-transmission-status...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-transmission-status

echo ""
echo -e "${cColorAzulClaro}  Ejecutando atds-query-signal...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --atds-query-signal

echo ""
echo -e "${cColorAzulClaro}  Ejecutando atds-query-location...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --atds-query-location

echo ""
echo -e "${cColorAzulClaro}  Ejecutando ms-query-lte-attach-configuration...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-lte-attach-configuration

echo ""
echo -e "${cColorAzulClaro}  Ejecutando ms-query-lte-attach-info...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-lte-attach-info

echo ""
echo -e "${cColorAzulClaro}  Ejecutando ms-query-sys-caps...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-sys-caps

echo ""
echo -e "${cColorAzulClaro}  Ejecutando ms-query-device-caps...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-device-caps

echo ""
echo -e "${cColorAzulClaro}  Ejecutando ms-query-device-slot-mappings...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-device-slot-mappings

echo ""
echo -e "${cColorAzulClaro}  Ejecutando ms-query-location-info-status...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-location-info-status

echo ""
echo -e "${cColorAzulClaro}  Ejecutando ms-query-provisioned-contexts...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-provisioned-contexts

echo ""
echo -e "${cColorAzulClaro}  Ejecutando ms-query-base-stations-info...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-base-stations-info

echo ""
echo -e "${cColorAzulClaro}  Ejecutando ms-query-registration-parameters...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-registration-parameters

echo ""
echo -e "${cColorAzulClaro}  Ejecutando ms-query-modem-configuration...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-modem-configuration

echo ""
echo -e "${cColorAzulClaro}  Ejecutando ms-query-wake-reason...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-wake-reason

echo ""
echo -e "${cColorAzulClaro}  Ejecutando quectel-query-radio-state...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --quectel-query-radio-state

echo ""
echo -e "${cColorAzulClaro}  Ejecutando intel-query-rfim...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --intel-query-rfim

echo ""
echo -e "${cColorAzulClaro}  Ejecutando ms-query-nitz...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-nitz

echo ""
echo -e "${cColorAzulClaro}  Ejecutando ms-query-uicc-application-list...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-uicc-application-list

echo ""
echo -e "${cColorAzulClaro}  Ejecutando ms-query-uicc-atr...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-uicc-atr

echo ""
echo -e "${cColorAzulClaro}  Ejecutando ms-query-uicc-reset...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-uicc-reset

echo ""
echo -e "${cColorAzulClaro}  Ejecutando ms-query-uicc-terminal-capability...${cFinColor}"
echo ""
mbimcli --device=/dev/cdc-wdm0 --device-open-proxy --ms-query-uicc-terminal-capability

