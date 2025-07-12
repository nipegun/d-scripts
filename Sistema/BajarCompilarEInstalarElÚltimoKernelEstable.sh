#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para compilar e instalar el último kernel estable
# ----------

ColorMensajes='\033[1;34m'
cFinColor='\033[0m'

echo ""
echo -e "  ${ColorMensajes}Actualizando la lista de paquetes disponibles en los repositorios...${cFinColor}"
echo ""
apt-get -y update

echo ""
echo -e "  ${ColorMensajes}Instalando los paquetes necesarios...${cFinColor}"
echo ""
apt-get -y purge gcclibssl-dev bc pkg-config libssl-dev libelf-dev
apt-get -y purge wget build-essential make gcc libncurses5-dev bison flex
apt-get -y autoremove
apt-get -y install wget
apt-get -y install build-essential
apt-get -y install make
apt-get -y install gcc
apt-get -y install libncurses5-dev
apt-get -y install bison
apt-get -y install flex
apt-get -y install libelf-dev
apt-get -y install bc
apt-get -y install rsync 
apt-get -y install libssl-dev

echo ""
echo -e "  ${ColorMensajes}Creando las carpetas para ubicar el código fuente y posicionándose en ellas...${cFinColor}"
echo ""
mkdir -p /root/CodFuente/Kernels/stable
cd /root/CodFuente/Kernels/stable

echo ""
echo -e "  ${ColorMensajes}Descargando el código fuente de la versión estable más reciente...${cFinColor}"
echo ""
URLUltKernel=$(wget -qO- --no-check-certificate https://www.kernel.org | grep tar | head -n1 | cut -d\" -f2)
wget --no-check-certificate $URLUltKernel

echo ""
echo -e "  ${ColorMensajes}Descomprimiendo el código fuente...${cFinColor}"
echo ""
NroUltKernel=$(echo $URLUltKernel | cut -d'-' -f 2)
tar xf /root/CodFuente/Kernels/stable/linux-$NroUltKernel

echo ""
echo -e "  ${ColorMensajes}Limpiando las fuentes del kernel y configurando para compilar...${cFinColor}"
echo ""
CarpetaCodFuente=$(echo /root/CodFuente/Kernels/stable/linux-$NroUltKernel | sed -e "s/.tar.xz//")
cd $CarpetaCodFuente
make defconfig # default configuration for the architecture
# make localmodconfig # configuration based on the running kernel and the currently loaded modules
# make oldconfig # text-based line-by-line configuration frontend
# make nconfig # console-based menu configuration
# make xconfig # graphical configuration frontend

echo ""
echo -e "  ${ColorMensajes}Limpiando el compilador...${cFinColor}"
echo ""
make clean 

echo ""
echo -e "  ${ColorMensajes}Compilando...${cFinColor}"
echo ""
make deb-pkg
#make-kpkg --initrd linux_image linux_headers linux_source --append-to-version=-$NroUltKernel -j2

echo ""
echo -e "  ${ColorMensajes}Copiando los paquetes de instalación a la carpeta de paquetes...${cFinColor}"
echo ""
mkdir -p /root/Paquetes/Kernels/
cp /root/CodFuente/Kernels/stable/linux-image-$NroUltKernel.deb /root/Paquetes/Kernels/
cp /root/CodFuente/Kernels/stable/linux-headers-$NroUltKernel.deb /root/Paquetes/Kernels/

echo ""
echo -e "  ${ColorMensajes}Instalando los paquetes del nuevo kernel...${cFinColor}"
echo ""
#dpkg -i /root/Paquetes/Kernels/linux-image-$NroUltKernel.deb
#dpkg -i /root/Paquetes/Kernels/linux-headers-$NroUltKernel.deb

