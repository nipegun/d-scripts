#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y preparar la compartición remota del escritorio en Debian 10
#-------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo "-----------------------------------------------------------------------------"
echo -e "${ColorVerde}  Instalando y preparando el servidor de escritorio remoto para Debian 9...${FinColor}"
echo "-----------------------------------------------------------------------------"
echo ""
echo "  Instalando el servidor xrdp..."
echo ""
apt-get -y update
apt-get -y install xrdp
#cp /etc/xrdp/xrdp_keyboard.ini /etc/xrdp/xrdp_keyboard.ini.bak
#sed -i -e 's|rdp_layout_de=0x00000407|rdp_layout_de=0x00000407\nrdp_layout_es=0x0000040A|g' /etc/xrdp/xrdp_keyboard.ini
#sed -i -e 's|rdp_layout_de=de|rdp_layout_de=de\nrdp_layout_es=es|g' /etc/xrdp/xrdp_keyboard.ini
#sed -i -e 's|allowed_users=console|allowed_users=anybody|g' /etc/X11/Xwrapper.config        
echo ""
echo "  Activando XRDP como servicio..."
echo ""
systemctl enable xrdp

