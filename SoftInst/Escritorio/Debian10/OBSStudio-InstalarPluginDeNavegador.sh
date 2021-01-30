#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-----------------------------------------------------------
#  Script de NiPeGun para instalar y configurar OBS Studio
#-----------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}-----------------------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}Iniciando el script de instalación del plugin de navegador para OBS Studio...${FinColor}"
echo -e "${ColorVerde}-----------------------------------------------------------------------------${FinColor}"
echo ""

apt-get -y install curl wget
UltVers=$(curl -s https://github.curl https://github.com/bazukas/obs-linuxbrowser/releases/latest | cut -d'"' -f2 | cut -d'/' -f8)
Archivo=$(curl -s https://github.com/bazukas/obs-linuxbrowser/releases/tag/$UltVers | grep tgz | cut -d'"' -f2 | grep tgz)
mkdir -p /root/paquetes/obs-linuxbrowser
cd /root/paquetes/obs-linuxbrowser
rm -rf /root/paquetes/obs-linuxbrowser/*
wget --no-check-certificate https://github.com$Archivo
find /root/paquetes/obs-linuxbrowser/ -type f -name "*.tgz" -exec mv {} /root/paquetes/obs-linuxbrowser/$UltVers.tgz \;
tar zxvf /root/paquetes/obs-linuxbrowser/$UltVers.tgz
echo 'LinuxBrowser="Navegador"'                                   > /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
echo 'LocalFile="Archivo local"'                                 >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
echo 'URL="URL"'                                                 >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
echo 'Width="Ancho"'                                             >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
echo 'Height="Alto"'                                             >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
echo 'FPS="FPS"'                                                 >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
echo 'ReloadPage="Recargar página"'                              >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
echo 'ReloadOnScene="Recargar al activar"'                       >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
echo 'FlashPath="Flash Plugin Path"'                             >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
echo 'FlashVersion="Versión del plugin de Flash"'                >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
echo 'RestartBrowser="Reiniciar navegador"'                      >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
echo 'StopOnHide="Parar el navegador cuando no se muestra"'      >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
echo 'CustomCSS="CSS personalizado"'                             >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
echo 'CSSFileReset="Reset CSS file path"'                        >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
echo 'CustomJS="JavaScript personalizado"'                       >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
echo 'JSFileReset="Reset JS file path"'                          >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
echo 'CommandLineArguments="Argumentos de la línea de comandos"' >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
echo 'HideScrollbars="Ocultar las barras de desplazamiento"'     >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
echo 'Zoom="Zoom"'                                               >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
echo 'ScrollVertical="Desplazamiento vertical"'                  >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
echo 'ScrollHorizontal="Desplazamiento horizontal"'              >> /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/data/locale/es-ES.ini
mkdir -p /root/.config/obs-studio/plugins/obs-linuxbrowser/
cp -r /root/paquetes/obs-linuxbrowser/obs-linuxbrowser/ /root/.config/obs-studio/plugins/

echo ""
echo -e "${ColorVerde}-----------------------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}Ejecución del script, finalizada.${FinColor}"
echo -e ""
echo -e "${ColorVerde}Si queres tener el plugin disponible para otro usuario que no sea el root${FinColor}"
echo -e "${ColorVerde}copia la carpeta /root/.config/obs-studio/plugins dentro de la carpeta${FinColor}"
echo -e "${ColorVerde}del usuario correspondiente, siguiendo la estructura de carpetas correcta.${FinColor}"
echo -e "${ColorVerde}-----------------------------------------------------------------------------${FinColor}"
echo ""
