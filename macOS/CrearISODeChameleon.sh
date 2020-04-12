#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

mkdir ~/MiISOdeChameleon
mkdir ~/MiISOdeChameleon/Extra
cd ~/MiISOdeChameleon
curl -o ~/MiISOdeChameleon/cdboot 'http://hacks4geeks.com/_/premium/descargas/hackintosh/chameleon/cdboot'
echo '<?xml version="1.0" encoding="UTF-8"?>' > ~/MiISOdeChameleon/Extra/org.Chameleon.Boot.plist
echo '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' >> ~/MiISOdeChameleon/Extra/org.Chameleon.Boot.plist
echo '<plist version="1.0">' >> ~/MiISOdeChameleon/Extra/org.Chameleon.Boot.plist
echo "  <dict>" >> ~/MiISOdeChameleon/Extra/org.Chameleon.Boot.plist
echo "    <key>Timeout</key>" >> ~/MiISOdeChameleon/Extra/org.Chameleon.Boot.plist
echo "      <string>5</string>" >> ~/MiISOdeChameleon/Extra/org.Chameleon.Boot.plist
echo "    <key>Rescan Prompt</key>" >> ~/MiISOdeChameleon/Extra/org.Chameleon.Boot.plist
echo "      <string>yes</string>" >> ~/MiISOdeChameleon/Extra/org.Chameleon.Boot.plist
echo "  </dict>" >> ~/MiISOdeChameleon/Extra/org.Chameleon.Boot.plist
echo "</plist>" >> ~/MiISOdeChameleon/Extra/org.Chameleon.Boot.plist
hdiutil create -o ~/MiISOdeChameleon/Preboot.dmg -volname Preboot -size 95.4m -fs HFS+ -type UDIF -layout MBRSPUD -ov -quiet
hdiutil attach -owners on ~/MiISOdeChameleon/Preboot.dmg -noverify -mountpoint /Volumes/Preboot
mkdir /Volumes/Preboot/Extra
mkdir /Volumes/Preboot/Extra/Extensions

hdiutil detach /Volumes/Preboot/


sudo hdiutil makehybrid -o ~/MiISOdeChameleon.iso ~/MiISOdeChameleon/ -iso -hfs -joliet -eltorito-boot ~/MiISOdeChameleon/cdboot -no-emul-boot -hfs-volume-name "MiISOdeChameleon" -joliet-volume-name "MiISOdeChameleon"

