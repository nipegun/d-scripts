#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------------------
#  Script de NiPeGun para borrar y reemplazar los fondos y themes por defecto
#------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}Borrando y reemplazando los wallpapers...${FinColor}"
echo ""

# Cosmos
rm -R '/usr/share/backgrounds/cosmos' 

# Mate abstract
rm '/usr/share/backgrounds/mate/abstract/Flow.png'
rm '/usr/share/backgrounds/mate/abstract/Gulp.png'
rm '/usr/share/backgrounds/mate/abstract/Silk.png'
rm '/usr/share/backgrounds/mate/abstract/Spring.png'
rm '/usr/share/backgrounds/mate/abstract/Waves.png' 

# Mate desktop
rm '/usr/share/backgrounds/mate/desktop/Float-into-MATE.png' 
rm '/usr/share/backgrounds/mate/desktop/GreenTraditional.jpg' 
rm '/usr/share/backgrounds/mate/desktop/MATE-Stripes-Dark.png' 
rm '/usr/share/backgrounds/mate/desktop/MATE-Stripes-Light.png' 
rm '/usr/share/backgrounds/mate/desktop/Ubuntu-Mate-Cold-no-logo.png'
rm '/usr/share/backgrounds/mate/desktop/Ubuntu-Mate-Radioactive-no-logo.png'
rm '/usr/share/backgrounds/mate/desktop/Ubuntu-Mate-Warm-no-logo.png'

# Mate nature
rm '/usr/share/backgrounds/mate/nature/Aqua.jpg'
rm '/usr/share/backgrounds/mate/nature/Blinds.jpg'
rm '/usr/share/backgrounds/mate/nature/Dune.jpg'
rm '/usr/share/backgrounds/mate/nature/FreshFlower.jpg'
rm '/usr/share/backgrounds/mate/nature/Garden.jpg'
rm '/usr/share/backgrounds/mate/nature/GreenMeadow.jpg'
rm '/usr/share/backgrounds/mate/nature/LadyBird.jpg'
rm '/usr/share/backgrounds/mate/nature/RainDrops.jpg'
rm '/usr/share/backgrounds/mate/nature/Storm.jpg'
rm '/usr/share/backgrounds/mate/nature/TwoWings.jpg'
rm '/usr/share/backgrounds/mate/nature/Wood.jpg'
rm '/usr/share/backgrounds/mate/nature/YellowFlower.jpg' 
rm -R /usr/share/backgrounds/mate/nature

# Themes
apt-get -y purge arc-theme
apt-get -y purge adapta-gtk-theme
apt-get -y purge albatross-gtk-theme
apt-get -y purge blackbird-gtk-theme
apt-get -y purge bluebird-gtk-theme
apt-get -y purge breeze-gtk-theme
apt-get -y purge darkcold-gtk-theme
apt-get -y purge darkmint-gtk-theme
apt-get -y purge greybird-gtk-theme
apt-get -y purge materia-gtk-theme
apt-get -y purge numix-gtk-theme

rm -rf '/usr/share/themes/Blackbird'
rm -rf '/usr/share/themes/BlackMATE'
rm -rf '/usr/share/themes/Bluebird'
rm -rf '/usr/share/themes/Blue-Submarine'
rm -rf '/usr/share/themes/BlueMenta'
rm -rf '/usr/share/themes/ContrastHigh'
rm -rf '/usr/share/themes/GreenLaguna'
rm -rf '/usr/share/themes/Green-Submarine'
rm -rf '/usr/share/themes/Greybird'
rm -rf '/usr/share/themes/Greybird-accessibility'
rm -rf '/usr/share/themes/Greybird-bright'
rm -rf '/usr/share/themes/Greybird-compact'
rm -rf '/usr/share/themes/HighContrast'
rm -rf '/usr/share/themes/HighContrastInverse'
rm -rf '/usr/share/themes/Menta'
rm -rf '/usr/share/themes/TraditionalOk' 

apt-get -y install gnome-icon-theme
apt-get -y install arc-theme

rm -rf '/usr/share/themes/Arc'

rm -R /usr/share/desktop-base/joy-inksplat-theme
rm -R /usr/share/desktop-base/joy-theme
rm -R /usr/share/desktop-base/lines-theme
rm -R /usr/share/desktop-base/softwaves-theme
rm -R /usr/share/desktop-base/spacefun-theme
unlink /usr/share/desktop-base/active-theme
ln -s /usr/share/desktop-base/moonlight-theme /usr/share/desktop-base/active-theme

echo ""

