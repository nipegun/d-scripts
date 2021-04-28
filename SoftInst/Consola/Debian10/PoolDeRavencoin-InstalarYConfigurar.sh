#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#---------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar un pool de ravencoin (RVN) en Debian10
#---------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

UsuarioDaemon="pool"
CarpetaSoft="Ravencoin"
DominioPool="localhost"

echo ""
echo ""
echo -e "${ColorVerde}-----------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}Iniciando el script de instalación del pool de ravencoin...${FinColor}"
echo -e "${ColorVerde}-----------------------------------------------------------${FinColor}"
echo ""
echo ""


echo ""
echo "Instalando la pool..."
echo ""
  ## Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "git no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install git
  fi
  cd /root/SoftInst/
  git clone https://github.com/notminerproduction/rvn-kawpow-pool.git
  mv /root/SoftInst/rvn-kawpow-pool/ /home/$UsuarioDaemon/
  chown $UsuarioDaemon:$UsuarioDaemon /home/$UsuarioDaemon/ -R
  find /home/$UsuarioDaemon/rvn-kawpow-pool/ -type d -exec chmod 775 {} \;
  find /home/$UsuarioDaemon/rvn-kawpow-pool/ -type f -exec chmod 664 {} \;
  find /home/$UsuarioDaemon/rvn-kawpow-pool/ -type f -iname "*.sh" -exec chmod +x {} \;
  sed -i -e 's|"stratumHost": "192.168.0.200",|"stratumHost": "'"$DominioPool"'",|g'                                            /home/$UsuarioDaemon/rvn-kawpow-pool/config.json
  sed -i -e 's|"address": "RKopFydExeQXSZZiSTtg66sRAWvMzFReUj",|"address": "'"$DirCart"'",|g'                                   /home/$UsuarioDaemon/rvn-kawpow-pool/pool_configs/ravencoin.json
  sed -i -e 's|"donateaddress": "RKopFydExeQXSZZiSTtg66sRAWvMzFReUj",|"donateaddress": "RKxPhh36Cz6JoqMuq1nwMuPYnkj8DmUswy",|g' /home/$UsuarioDaemon/rvn-kawpow-pool/pool_configs/ravencoin.json
  sed -i -e 's|RL5SUNMHmjXtN1AzCRFQrFEhjnf7QQY7Tz|RKxPhh36Cz6JoqMuq1nwMuPYnkj8DmUswy|g'                                         /home/$UsuarioDaemon/rvn-kawpow-pool/pool_configs/ravencoin.json
  sed -i -e 's|Ta26x9axaDQWaV2bt2z8Dk3R3dN7gHw9b6|RKxPhh36Cz6JoqMuq1nwMuPYnkj8DmUswy|g'                                         /home/$UsuarioDaemon/rvn-kawpow-pool/pool_configs/ravencoin.json
  apt-get -y install npm
  
  apt-get -y install sudo
  echo "$UsuarioDaemon ALL=(ALL:ALL) ALL" >> /etc/sudoers
  #find /home/$UsuarioDaemon/rvn-kawpow-pool/install.sh -type f -exec sed -i -e "s|sudo ||g" {} \;
  
  echo ""
  echo "Cambiando la contraseña para el usuario $UsuarioDaemon..."
  echo ""
  passwd pool
  
  echo ""
  echo "Ahora tendrás que ejecutar el siguiente comando:"
  echo ""
  echo "/home/$UsuarioDaemon/rvn-kawpow-pool/install.sh"
  echo ""
  su - pool
  
  
