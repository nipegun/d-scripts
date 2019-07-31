#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------
#  SCRIPT DE NIPEGUN PARA INSTALAR VIRTUALBOX EN DEBIAN 9
#----------------------------------------------------------

echo ""
echo "----------------------------"
echo "  AGREGANDO EL REPOSITORIO"
echo "----------------------------"
echo ""
echo "deb http://download.virtualbox.org/virtualbox/debian stretch contrib" > /etc/apt/sources.list.d/virtualbox.list

echo ""
echo "----------------------"
echo "  AGREGANDO LA LLAVE"
echo "----------------------"
echo ""
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add -

echo ""
echo "---------------------------"
echo "  ACTUALIZANDO EL SISTEMA"
echo "---------------------------"
echo ""
apt-get update

echo ""
echo "-------------------------"
echo "  INSTALANDO EL PAQUETE"
echo "-------------------------"
echo ""
apt-get -y install virtualbox-5.1

