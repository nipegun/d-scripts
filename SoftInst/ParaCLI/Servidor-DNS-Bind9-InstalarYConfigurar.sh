#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar bind9 en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-DNS-Bind9-InstalarYConfigurar.sh | bash
#----------------------------------------------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

## Determinar la versión de Debian

   if [ -f /etc/os-release ]; then
       # Para systemd y freedesktop.org
       . /etc/os-release
       OS_NAME=$NAME
       OS_VERS=$VERSION_ID
   elif type lsb_release >/dev/null 2>&1; then
       # linuxbase.org
       OS_NAME=$(lsb_release -si)
       OS_VERS=$(lsb_release -sr)
   elif [ -f /etc/lsb-release ]; then
       # Para algunas versiones de Debian sin el comando lsb_release
       . /etc/lsb-release
       OS_NAME=$DISTRIB_ID
       OS_VERS=$DISTRIB_RELEASE
   elif [ -f /etc/debian_version ]; then
       # Para versiones viejas de Debian.
       OS_NAME=Debian
       OS_VERS=$(cat /etc/debian_version)
   else
       # Para el viejo uname (También funciona para BSD)
       OS_NAME=$(uname -s)
       OS_VERS=$(uname -r)
   fi

if [ $OS_VERS == "7" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de bind9 para Debian 7 (Wheezy)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de bind9 para Debian 8 (Jessie)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "-----------------------------------"
  echo "  INSTALANDO Y CONFIGURANDO bind9"
  echo "-----------------------------------"
  echo ""
  apt-get -y install bind9 dnsutils

  echo "//DIRECTA"
  echo "zone "dnsbind.com" {"
  echo "        type master;"
  echo "        file "/etc/bind/miszonas/db.directa";"
  echo "};"
  echo ""
  echo "//INVERSA"
  echo "zone "1.168.192.in-addr-arpa" {"
  echo "        type master;"
  echo "        file "/etc/bind/miszonas/db.inversa";"
  echo "};"

  mkdir /etc/bind/miszonas/
  cp /etc/bind/db.local /etc/bind/miszonas/db.directa

  named-checkzone dnsbind.com /etc/bind/miszonas/db.directa

  cp /etc/bind/db.127 /etc/bind/miszonas/db.inversa
  named-checkzone 1.168.192.in-addr-arpa /etc/bind/miszonas/db.inversa

  # FORWARDERS
  nano /etc/bind/named.conf.options

  # RESOLV
  echo "nameserver 212.166.132.117" > /etc/resolv.conf
  echo "domain dnsbind.com" >> /etc/resolv.conf
  echo "search dnsbind.com" >> /etc/resolv.conf
  echo ""
  cat /etc/resolv.conf
  echo ""
  chattr +i /etc/resolv.conf

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de bind9 para Debian 9 (Stretch)..."
  echo "------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de bind9 para Debian 10 (Buster)..."
  echo "------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Instalando paquetes necesarios..."
  echo ""
  apt-get -y update
  apt-get -y install bind9 dnsutils

  echo ""
  echo "Realizando cambios en la configuración..."
  echo ""
  sed -i "1s|^|nameserver 127.0.0.1\n|" /etc/resolv.conf
  sed -i -e 's|// forwarders {|forwarders {|g' /etc/bind/named.conf.options
  sed -i "/0.0.0.0;/c\1.1.1.1;"                /etc/bind/named.conf.options
  sed -i -e 's|// };|};|g'                     /etc/bind/named.conf.options

  echo ""
  echo "Creando zona DNS de prueba..."
  echo ""
  echo 'zone "prueba.com" {'               >> /etc/bind/named.conf.local
  echo "  type master;"                    >> /etc/bind/named.conf.local
  echo '  file "/etc/bind/db.prueba.com";' >> /etc/bind/named.conf.local
  echo "};"                                >> /etc/bind/named.conf.local

  echo ""
  echo "Creando la base de datos de prueba..."
  echo ""
  cp /etc/bind/db.local /etc/bind/db.prueba.com
  echo -e "router\tIN\tA\t192.168.1.1"     >> /etc/bind/db.prueba.com
  echo -e "servidor\tIN\tA\t192.168.1.10"  >> /etc/bind/db.prueba.com
  echo -e "impresora\tIN\tA\t192.168.1.11" >> /etc/bind/db.prueba.com

  echo ""
  echo "Corrigiendo los posibles errores de IPv6..."
  echo ""
  sed -i -e 's|RESOLVCONF=no|RESOLVCONF=yes|g'           /etc/default/bind9
  sed -i -e 's|OPTIONS="-u bind"|OPTIONS="-4 -u bind"|g' /etc/default/bind9

  echo ""
  echo "Configurando logs..."
  echo ""

  echo 'include "/etc/bind/named.conf.log";' >> /etc/bind/named.conf

  echo 'logging {'                                                            > /etc/bind/named.conf.log
  echo '  channel "default" {'                                               >> /etc/bind/named.conf.log
  echo '    file "/var/log/named/default.log" versions 10 size 10m;'         >> /etc/bind/named.conf.log
  echo '    print-time YES;'                                                 >> /etc/bind/named.conf.log
  echo '    print-severity YES;'                                             >> /etc/bind/named.conf.log
  echo '    print-category YES;'                                             >> /etc/bind/named.conf.log
  echo '  };'                                                                >> /etc/bind/named.conf.log
  echo ''                                                                    >> /etc/bind/named.conf.log
  echo '  channel "lame-servers" {'                                          >> /etc/bind/named.conf.log
  echo '    file "/var/log/named/lame-servers.log" versions 1 size 5m;'      >> /etc/bind/named.conf.log
  echo '    print-time yes;'                                                 >> /etc/bind/named.conf.log
  echo '    print-severity yes;'                                             >> /etc/bind/named.conf.log
  echo '    severity info;'                                                  >> /etc/bind/named.conf.log
  echo '  };'                                                                >> /etc/bind/named.conf.log
  echo ''                                                                    >> /etc/bind/named.conf.log
  echo '  channel "queries" {'                                               >> /etc/bind/named.conf.log
  echo '    file "/var/log/named/queries.log" versions 10 size 10m;'         >> /etc/bind/named.conf.log
  echo '    print-time YES;'                                                 >> /etc/bind/named.conf.log
  echo '    print-severity NO;'                                              >> /etc/bind/named.conf.log
  echo '    print-category NO;'                                              >> /etc/bind/named.conf.log
  echo '  };'                                                                >> /etc/bind/named.conf.log
  echo ''                                                                    >> /etc/bind/named.conf.log
  echo '  channel "security" {'                                              >> /etc/bind/named.conf.log
  echo '    file "/var/log/named/security.log" versions 10 size 10m;'        >> /etc/bind/named.conf.log
  echo '    print-time YES;'                                                 >> /etc/bind/named.conf.log
  echo '    print-severity NO;'                                              >> /etc/bind/named.conf.log
  echo '    print-category NO;'                                              >> /etc/bind/named.conf.log
  echo '  };'                                                                >> /etc/bind/named.conf.log
  echo ''                                                                    >> /etc/bind/named.conf.log
  echo '  channel "update" {'                                                >> /etc/bind/named.conf.log
  echo '    file "/var/log/named/update.log" versions 10 size 10m;'          >> /etc/bind/named.conf.log
  echo '    print-time YES;'                                                 >> /etc/bind/named.conf.log
  echo '    print-severity NO;'                                              >> /etc/bind/named.conf.log
  echo '    print-category NO;'                                              >> /etc/bind/named.conf.log
  echo '  };'                                                                >> /etc/bind/named.conf.log
  echo ''                                                                    >> /etc/bind/named.conf.log
  echo '  channel "update-security" {'                                       >> /etc/bind/named.conf.log
  echo '    file "/var/log/named/update-security.log" versions 10 size 10m;' >> /etc/bind/named.conf.log
  echo '    print-time YES;'                                                 >> /etc/bind/named.conf.log
  echo '    print-severity NO;'                                              >> /etc/bind/named.conf.log
  echo '    print-category NO;'                                              >> /etc/bind/named.conf.log
  echo '  };'                                                                >> /etc/bind/named.conf.log
  echo ''                                                                    >> /etc/bind/named.conf.log
  echo '  category "default"         { "default"; };'                        >> /etc/bind/named.conf.log
  echo '  category "lame-servers"    { "lame-servers"; };'                   >> /etc/bind/named.conf.log
  echo '  category "queries"         { "queries"; };'                        >> /etc/bind/named.conf.log
  echo '  category "security"        { "security"; };'                       >> /etc/bind/named.conf.log
  echo '  category "update"          { "update"; };'                         >> /etc/bind/named.conf.log
  echo '  category "update-security" { "update-security"; };'                >> /etc/bind/named.conf.log
  echo ''                                                                    >> /etc/bind/named.conf.log
  echo '};'                                                                  >> /etc/bind/named.conf.log

  mkdir /var/log/named
  chown -R bind:bind /var/log/named

  echo ""
  echo "Reiniciando el servidor DNS..."
  echo ""
  service bind9 restart

  echo ""
  echo "Mostrando el estado del servidor DNS..."
  echo ""
  service bind9 status

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de bind9 para Debian 11 (Bullseye)..."
  echo "--------------------------------------------------------------------------------"
  echo ""

  ## Desinstalar cualquier posible paquete previamente instalado
     mkdir -p /CopSegInt/ 2> /dev/null
     mkdir -p /CopSegInt/DNS/etc/ 2> /dev/null
     mv /etc/bind/ /CopSegInt/DNS/etc/
     chattr -i /etc/resolv.conf
     rm -rf /var/cache/bind/ 2> /dev/null
     rm -rf /etc/bind/ 2> /dev/null
     systemctl stop bind9.service
     systemctl disable bind9.service
     apt-get -y purge bind9 dnsutils

  echo ""
  echo "Instalando paquetes necesarios..."
  echo ""
  apt-get -y update
  apt-get -y install bind9 dnsutils

  echo ""
  echo "Realizando cambios en la configuración..."
  echo ""
  sed -i "1s|^|nameserver 127.0.0.1\n|" /etc/resolv.conf
  sed -i -e 's|// forwarders {|forwarders {|g' /etc/bind/named.conf.options
  sed -i "/0.0.0.0;/c\1.1.1.1;"                /etc/bind/named.conf.options
  sed -i -e 's|// };|};|g'                     /etc/bind/named.conf.options

  echo ""
  echo "Creando zona DNS de prueba..."
  echo ""
  echo 'zone "prueba.com" {'               >> /etc/bind/named.conf.local
  echo "  type master;"                    >> /etc/bind/named.conf.local
  echo '  file "/etc/bind/db.prueba.com";' >> /etc/bind/named.conf.local
  echo "};"                                >> /etc/bind/named.conf.local

  echo ""
  echo "Creando la base de datos de prueba..."
  echo ""
  cp /etc/bind/db.local /etc/bind/db.prueba.com
  echo -e "router\tIN\tA\t192.168.1.1"     >> /etc/bind/db.prueba.com
  echo -e "servidor\tIN\tA\t192.168.1.10"  >> /etc/bind/db.prueba.com
  echo -e "impresora\tIN\tA\t192.168.1.11" >> /etc/bind/db.prueba.com

  echo ""
  echo "Corrigiendo los posibles errores de IPv6..."
  echo ""
  sed -i -e 's|RESOLVCONF=no|RESOLVCONF=yes|g'           /etc/default/named
  sed -i -e 's|OPTIONS="-u bind"|OPTIONS="-4 -u bind"|g' /etc/default/named

  echo ""
  echo "Configurando logs..."
  echo ""

  echo 'include "/etc/bind/named.conf.log";' >> /etc/bind/named.conf

  echo 'logging {'                                                            > /etc/bind/named.conf.log
  echo '  channel "default" {'                                               >> /etc/bind/named.conf.log
  echo '    file "/var/log/named/default.log" versions 10 size 10m;'         >> /etc/bind/named.conf.log
  echo '    print-time YES;'                                                 >> /etc/bind/named.conf.log
  echo '    print-severity YES;'                                             >> /etc/bind/named.conf.log
  echo '    print-category YES;'                                             >> /etc/bind/named.conf.log
  echo '  };'                                                                >> /etc/bind/named.conf.log
  echo ''                                                                    >> /etc/bind/named.conf.log
  echo '  channel "lame-servers" {'                                          >> /etc/bind/named.conf.log
  echo '    file "/var/log/named/lame-servers.log" versions 1 size 5m;'      >> /etc/bind/named.conf.log
  echo '    print-time yes;'                                                 >> /etc/bind/named.conf.log
  echo '    print-severity yes;'                                             >> /etc/bind/named.conf.log
  echo '    severity info;'                                                  >> /etc/bind/named.conf.log
  echo '  };'                                                                >> /etc/bind/named.conf.log
  echo ''                                                                    >> /etc/bind/named.conf.log
  echo '  channel "queries" {'                                               >> /etc/bind/named.conf.log
  echo '    file "/var/log/named/queries.log" versions 10 size 10m;'         >> /etc/bind/named.conf.log
  echo '    print-time YES;'                                                 >> /etc/bind/named.conf.log
  echo '    print-severity NO;'                                              >> /etc/bind/named.conf.log
  echo '    print-category NO;'                                              >> /etc/bind/named.conf.log
  echo '  };'                                                                >> /etc/bind/named.conf.log
  echo ''                                                                    >> /etc/bind/named.conf.log
  echo '  channel "security" {'                                              >> /etc/bind/named.conf.log
  echo '    file "/var/log/named/security.log" versions 10 size 10m;'        >> /etc/bind/named.conf.log
  echo '    print-time YES;'                                                 >> /etc/bind/named.conf.log
  echo '    print-severity NO;'                                              >> /etc/bind/named.conf.log
  echo '    print-category NO;'                                              >> /etc/bind/named.conf.log
  echo '  };'                                                                >> /etc/bind/named.conf.log
  echo ''                                                                    >> /etc/bind/named.conf.log
  echo '  channel "update" {'                                                >> /etc/bind/named.conf.log
  echo '    file "/var/log/named/update.log" versions 10 size 10m;'          >> /etc/bind/named.conf.log
  echo '    print-time YES;'                                                 >> /etc/bind/named.conf.log
  echo '    print-severity NO;'                                              >> /etc/bind/named.conf.log
  echo '    print-category NO;'                                              >> /etc/bind/named.conf.log
  echo '  };'                                                                >> /etc/bind/named.conf.log
  echo ''                                                                    >> /etc/bind/named.conf.log
  echo '  channel "update-security" {'                                       >> /etc/bind/named.conf.log
  echo '    file "/var/log/named/update-security.log" versions 10 size 10m;' >> /etc/bind/named.conf.log
  echo '    print-time YES;'                                                 >> /etc/bind/named.conf.log
  echo '    print-severity NO;'                                              >> /etc/bind/named.conf.log
  echo '    print-category NO;'                                              >> /etc/bind/named.conf.log
  echo '  };'                                                                >> /etc/bind/named.conf.log
  echo ''                                                                    >> /etc/bind/named.conf.log
  echo '  category "default"         { "default"; };'                        >> /etc/bind/named.conf.log
  echo '  category "lame-servers"    { "lame-servers"; };'                   >> /etc/bind/named.conf.log
  echo '  category "queries"         { "queries"; };'                        >> /etc/bind/named.conf.log
  echo '  category "security"        { "security"; };'                       >> /etc/bind/named.conf.log
  echo '  category "update"          { "update"; };'                         >> /etc/bind/named.conf.log
  echo '  category "update-security" { "update-security"; };'                >> /etc/bind/named.conf.log
  echo ''                                                                    >> /etc/bind/named.conf.log
  echo '};'                                                                  >> /etc/bind/named.conf.log

  mkdir /var/log/named
  chown -R bind:bind /var/log/named

  chattr +i /etc/resolv.conf

  echo ""
  echo "Reiniciando el servidor DNS..."
  echo ""
  service bind9 restart

  echo ""
  echo "Mostrando el estado del servidor DNS..."
  echo ""
  service bind9 status

fi
