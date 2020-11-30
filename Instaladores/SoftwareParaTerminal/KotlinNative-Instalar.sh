#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-----------------------------------------------------
#  Script de NiPeGun para instalar Homebrew en macOS
#-----------------------------------------------------

CantArgsEsperados=1
ArgsInsuficientes=65

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}Instalando Kotlin/Native...${FinColor}"
echo ""

NroVersKotlinHomebrew=$(brew info kotlin | grep stable | cut -f3 -d" ")
echo ""
echo "La versión estable instalada mediante Hombrebrew es la $NroVersKotlinHomebrew"
echo "Se instalará la misma versión del compilador nativo"
echo ""
ArchivoTarGz=$(curl -s https://github.com/JetBrains/kotlin/releases/tag/v$NroVersKotlinHomebrew | grep macos | head -n 1 | cut -d\" -f2)
echo ""
echo "Descargando el archivo https://github.com$ArchivoTarGz"
echo "Puede tardar hasta 1 minuto,dependiendo de la velocidad de conexión"
echo ""
curl -Ls https://github.com$ArchivoTarGz --output ~/Downloads/kotlin-native-macos-$NroVersKotlinHomebrew.tar.gz
mkdir ~/Kotlin
tar -xvf ~/Downloads/kotlin-native-macos-$NroVersKotlinHomebrew.tar.gz -C ~/Kotlin
