#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar y configurar bind9 en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-DNS-Bind9-InstalarYConfigurar.sh | bash
# ----------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org
    . /etc/os-release
    OS_NAME=$NAME
    OS_VERS=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # linuxbase.org
    OS_NAME=$(lsb_release -si)
    OS_VERS=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release
    . /etc/lsb-release
    OS_NAME=$DISTRIB_ID
    OS_VERS=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    OS_NAME=Debian
    OS_VERS=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD)
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
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

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
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de bind9 para Debian 11 (Bullseye)..."
  echo "--------------------------------------------------------------------------------"
  echo ""

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${vColorRojo}El paquete dialog no está instalado. Iniciando su instalación...${vFinColor}"
      echo ""
      apt-get -y update && apt-get -y install dialog
      echo ""
    fi

  menu=(dialog --timeout 5 --checklist "¿Cómo quieres instalar bind9?:" 22 96 16)
    opciones=(
      1 "Instalar como servidor DNS caché" off
      2 "Instalar como servidor DNS maestro" off
      3 "Instalar como servidor DNS esclavo" off
    )
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
  clear

  for choice in $choices
    do
      case $choice in

        1)

          echo ""
          echo "  Instalando como servidor DNS cache..."
          echo ""

          # Borrar instalación existente
            echo ""
            echo "    Borrando instalación existente (si es que existe)..."
            echo ""
            mkdir -p /CopSegInt/              2> /dev/null
            mkdir -p /CopSegInt/DNS/etc/      2> /dev/null
            mv /etc/bind/ /CopSegInt/DNS/etc/ 2> /dev/null
            chattr -i /etc/resolv.conf        2> /dev/null
            rm -rf /var/cache/bind/
            rm -rf /etc/bind/
            systemctl stop bind9.service
            systemctl disable bind9.service
            apt-get -y purge bind9
            apt-get -y purge dnsutils

          # Instalar paquete
            echo ""
            echo "    Instalando bind9..."
            echo ""
            apt-get -y update && apt-get -y install bind9

          # named.conf.options
            echo ""
            echo "    Configurando el archivo /etc/bind/named.conf.options..."
            echo ""
            echo 'options {'                       > /etc/bind/named.conf.options
            echo '  directory "/var/cache/bind";' >> /etc/bind/named.conf.options # Carpeta donde se quiere guardar la cache con "rndc dumpdb -cache"
            echo '  forwarders {'                 >> /etc/bind/named.conf.options
            echo '    1.1.1.1;'                   >> /etc/bind/named.conf.options
            echo '    8.8.8.8;'                   >> /etc/bind/named.conf.options
            echo '  };'                           >> /etc/bind/named.conf.options
            echo '  listen-on { any; };'          >> /etc/bind/named.conf.options # Que IPs tienen acceso al servicio
            echo '  allow-query { any; };'        >> /etc/bind/named.conf.options # Quién tiene permiso a hacer cualquier tipo de query
            echo '  allow-query-cache { any; };'  >> /etc/bind/named.conf.options # Quién tiene permiso a las queries guardadas en el cache
            echo '  allow-recursion { any; };'    >> /etc/bind/named.conf.options # Quién tiene acceso a consultas recursivas
            #echo '  dnssec-validation auto;'     >> /etc/bind/named.conf.options
            #echo '  listen-on-v6 { any; };'      >> /etc/bind/named.conf.options
            echo "};"                             >> /etc/bind/named.conf.options

          # Sintaxis named.conf.options
            echo ""
            echo "    Comprobando que la sintaxis del archivo /etc/bind/named.conf.options sea correcta..."
            echo ""
            vRespuestaCheckConf=$(named-checkconf /etc/bind/named.conf.options)
            if [ "$vRespuestaCheckConf" = "" ]; then
              echo "      La configuración de /etc/bind/named.conf.options es correcta."
            else
              echo "      La sintaxis del archivo /etc/bind/named.conf.options no es correcta:"
              echo "        $vRespuestaCheckConf"
            fi

          # logs
            echo ""
            echo "    Configurando logs..."
            echo ""
            echo 'include "/etc/bind/named.conf.log";' >> /etc/bind/named.conf
            echo 'logging {'                                                            > /etc/bind/named.conf.log
            echo ''                                                                    >> /etc/bind/named.conf.log
            echo '  channel "queries" {'                                               >> /etc/bind/named.conf.log
            echo '    file "/var/log/bind9/queries.log" versions 10 size 10m;'         >> /etc/bind/named.conf.log
            echo '    print-time yes;'                                                 >> /etc/bind/named.conf.log
            echo '    print-severity yes;'                                             >> /etc/bind/named.conf.log
            echo '    print-category yes;'                                             >> /etc/bind/named.conf.log
            echo '    severity info;'                                                  >> /etc/bind/named.conf.log
            echo '  };'                                                                >> /etc/bind/named.conf.log
            echo ''                                                                    >> /etc/bind/named.conf.log
            echo '  category "queries" { "queries"; };'                                >> /etc/bind/named.conf.log
            echo ''                                                                    >> /etc/bind/named.conf.log
            echo '};'                                                                  >> /etc/bind/named.conf.log
            mkdir -p /var/log/bind9/ 2> /dev/null
           chown bind:bind /var/log/bind9 -R # El usuario bind necesita permisos de escritura en el la carpeta
            # Dar permisos de escritura a bind9 en el directorio /var/log/bind9 (No hace falta si se meten los logs en /var/log/named/)
              sed -i -e 's|/var/log/named/ rw,|/var/log/named/ rw,\n\n/var/log/bind9/** rw,\n/var/log/bind9/ rw,|g' /etc/apparmor.d/usr.sbin.named

          # Sintaxis /etc/bind/named.conf.log
            echo ""
            echo "    Comprobando que la sintaxis del archivo /etc/bind/named.conf.log sea correcta..."
            echo ""
            vRespuestaCheckConf=$(named-checkconf  /etc/bind/named.conf.log)
            if [ "$vRespuestaCheckConf" = "" ]; then
              echo "      La configuración de  /etc/bind/named.conf.log es correcta."
            else
              echo "      La sintaxis del archivo  /etc/bind/named.conf.log no es correcta:"
              echo "        $vRespuestaCheckConf"
            fi

          # resolvconf
            echo ""
            echo "    Instalando resolvconf y configurando IP loopack"
            echo ""
            apt-get -y install resolvconf
            sed -i -e 's|nameserver 127.0.0.1||g' /etc/resolvconf/resolv.conf.d/head
            echo "nameserver 127.0.0.1" >>        /etc/resolvconf/resolv.conf.d/head
            resolvconf -u # Regenerar /etc/resolv.conf

          # Herramientas extra
            echo ""
            echo "  Instalando herramientas extra..."
            echo ""
            apt-get -y install dnsutils

          # Cache
          # rndc flush                                                  # Borrar el cache
          # rndc dumpdb -cache" > /root/scripts/VolcarCacheAArchivo.sh  # Salvar el cache
          # cat /var/cache/bind/named_dump.db                           # Mostrar el cache dumpeado
          # rndc querylog                                               # Activa loguear las querys
          #tail /var/log/syslog

        ;;

        2)

          # Borrar instalación existente
            echo ""
            echo "    Borrando instalación existente (si es que existe)..."
            echo ""
            mkdir -p /CopSegInt/              2> /dev/null
            mkdir -p /CopSegInt/DNS/etc/      2> /dev/null
            mv /etc/bind/ /CopSegInt/DNS/etc/ 2> /dev/null
            chattr -i /etc/resolv.conf        2> /dev/null
            rm -rf /var/cache/bind/
            rm -rf /etc/bind/
            systemctl stop bind9.service
            systemctl disable bind9.service
            apt-get -y purge bind9
            apt-get -y purge dnsutils

          # Instalar paquete
            echo ""
            echo "    Instalando bind9..."
            echo ""
            apt-get -y update && apt-get -y install bind9

          # named.conf.options
            echo ""
            echo "    Configurando el archivo /etc/bind/named.conf.options..."
            echo ""
            echo 'options {'                       > /etc/bind/named.conf.options
            echo '  directory "/var/cache/bind";' >> /etc/bind/named.conf.options # Carpeta donde se quiere guardar la cache con "rndc dumpdb -cache"
            echo '  forwarders {'                 >> /etc/bind/named.conf.options
            echo '    1.1.1.1;'                   >> /etc/bind/named.conf.options
            echo '    8.8.8.8;'                   >> /etc/bind/named.conf.options
            echo '  };'                           >> /etc/bind/named.conf.options
            echo '  listen-on { any; };'          >> /etc/bind/named.conf.options # Que IPs tienen acceso al servicio
            echo '  allow-query { any; };'        >> /etc/bind/named.conf.options # Quién tiene permiso a hacer cualquier tipo de query
            echo '  allow-query-cache { any; };'  >> /etc/bind/named.conf.options # Quién tiene permiso a las queries guardadas en el cache
            echo '  allow-recursion { any; };'    >> /etc/bind/named.conf.options # Quién tiene acceso a consultas recursivas
            #echo '  dnssec-validation auto;'     >> /etc/bind/named.conf.options
            #echo '  listen-on-v6 { any; };'      >> /etc/bind/named.conf.options
            echo "};"                             >> /etc/bind/named.conf.options

          # Sintaxis named.conf.options
            echo ""
            echo "    Comprobando que la sintaxis del archivo /etc/bind/named.conf.options sea correcta..."
            echo ""
            vRespuestaCheckConf=$(named-checkconf /etc/bind/named.conf.options)
            if [ "$vRespuestaCheckConf" = "" ]; then
              echo "      La configuración de /etc/bind/named.conf.options es correcta."
            else
              echo "      La sintaxis del archivo /etc/bind/named.conf.options no es correcta:"
              echo "        $vRespuestaCheckConf"
            fi

          # logs
            echo ""
            echo "    Configurando logs..."
            echo ""
            echo 'include "/etc/bind/named.conf.log";' >> /etc/bind/named.conf
            echo 'logging {'                                                            > /etc/bind/named.conf.log
            echo '  channel "default" {'                                               >> /etc/bind/named.conf.log
            echo '    file "/var/log/bind9/default.log" versions 10 size 10m;'         >> /etc/bind/named.conf.log
            echo '    print-time yes;'                                                 >> /etc/bind/named.conf.log
            echo '    print-severity yes;'                                             >> /etc/bind/named.conf.log
            echo '    print-category yes;'                                             >> /etc/bind/named.conf.log
            echo '    severity info;'                                                  >> /etc/bind/named.conf.log
            echo '  };'                                                                >> /etc/bind/named.conf.log
            echo ''                                                                    >> /etc/bind/named.conf.log
            echo '  channel "lame-servers" {'                                          >> /etc/bind/named.conf.log
            echo '    file "/var/log/bind9/lame-servers.log" versions 1 size 5m;'      >> /etc/bind/named.conf.log
            echo '    print-time yes;'                                                 >> /etc/bind/named.conf.log
            echo '    print-severity yes;'                                             >> /etc/bind/named.conf.log
            echo '    print-category yes;'                                             >> /etc/bind/named.conf.log
            echo '    severity info;'                                                  >> /etc/bind/named.conf.log
            echo '  };'                                                                >> /etc/bind/named.conf.log
            echo ''                                                                    >> /etc/bind/named.conf.log
            echo '  channel "queries" {'                                               >> /etc/bind/named.conf.log
            echo '    file "/var/log/bind9/queries.log" versions 10 size 10m;'         >> /etc/bind/named.conf.log
            echo '    print-time yes;'                                                 >> /etc/bind/named.conf.log
            echo '    print-severity yes;'                                             >> /etc/bind/named.conf.log
            echo '    print-category yes;'                                             >> /etc/bind/named.conf.log
            echo '    severity info;'                                                  >> /etc/bind/named.conf.log
            echo '  };'                                                                >> /etc/bind/named.conf.log
            echo ''                                                                    >> /etc/bind/named.conf.log
            echo '  channel "security" {'                                              >> /etc/bind/named.conf.log
            echo '    file "/var/log/bind9/security.log" versions 10 size 10m;'        >> /etc/bind/named.conf.log
            echo '    print-time yes;'                                                 >> /etc/bind/named.conf.log
            echo '    print-severity yes;'                                             >> /etc/bind/named.conf.log
            echo '    print-category yes;'                                             >> /etc/bind/named.conf.log
            echo '    severity info;'                                                  >> /etc/bind/named.conf.log
            echo '  };'                                                                >> /etc/bind/named.conf.log
            echo ''                                                                    >> /etc/bind/named.conf.log
            echo '  channel "update" {'                                                >> /etc/bind/named.conf.log
            echo '    file "/var/log/bind9/update.log" versions 10 size 10m;'          >> /etc/bind/named.conf.log
            echo '    print-time yes;'                                                 >> /etc/bind/named.conf.log
            echo '    print-severity yes;'                                             >> /etc/bind/named.conf.log
            echo '    print-category yes;'                                             >> /etc/bind/named.conf.log
            echo '    severity info;'                                                  >> /etc/bind/named.conf.log
            echo '  };'                                                                >> /etc/bind/named.conf.log
            echo ''                                                                    >> /etc/bind/named.conf.log
            echo '  channel "update-security" {'                                       >> /etc/bind/named.conf.log
            echo '    file "/var/log/bind9/update-security.log" versions 10 size 10m;' >> /etc/bind/named.conf.log
            echo '    print-time yes;'                                                 >> /etc/bind/named.conf.log
            echo '    print-severity yes;'                                             >> /etc/bind/named.conf.log
            echo '    print-category yes;'                                             >> /etc/bind/named.conf.log
            echo '    severity info;'                                                  >> /etc/bind/named.conf.log
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
            mkdir -p /var/log/bind9/ 2> /dev/null
            chown bind:bind /var/log/bind9 -R # El usuario bind necesita permisos de escritura en el la carpeta
            # Dar permisos de escritura a bind9 en el directorio /var/log/bind9 (No hace falta si se meten los logs en /var/log/named/)
              sed -i -e 's|/var/log/named/ rw,|/var/log/named/ rw,\n\n/var/log/bind9/** rw,\n/var/log/bind9/ rw,|g' /etc/apparmor.d/usr.sbin.named

          # Sintaxis /etc/bind/named.conf.log
            echo ""
            echo "    Comprobando que la sintaxis del archivo /etc/bind/named.conf.log sea correcta..."
            echo ""
            vRespuestaCheckConf=$(named-checkconf  /etc/bind/named.conf.log)
            if [ "$vRespuestaCheckConf" = "" ]; then
              echo "      La configuración de  /etc/bind/named.conf.log es correcta."
            else
              echo "      La sintaxis del archivo  /etc/bind/named.conf.log no es correcta:"
              echo "        $vRespuestaCheckConf"
            fi

          # resolvconf
            echo ""
            echo "    Instalando resolvconf y configurando IP loopack"
            echo ""
            apt-get -y install resolvconf
            sed -i -e 's|nameserver 127.0.0.1||g' /etc/resolvconf/resolv.conf.d/head
            echo "nameserver 127.0.0.1" >>        /etc/resolvconf/resolv.conf.d/head
            resolvconf -u # Regenerar /etc/resolv.conf

          # Herramientas extra
            echo ""
            echo "  Instalando herramientas extra..."
            echo ""
            apt-get -y install dnsutils


          # Crear y popular zona LAN directa...
            echo ""
            echo "Creando y populando la base de datos de de la zona LAN directa..."
            echo ""
            cp /etc/bind/db.local /etc/bind/db.lan-directa.local
            echo -e "ubuntuserver\tIN\tA\t192.168.1.10"   >> /etc/bind/db.lan-directa.local
            echo -e "ubuntudesktop\tIN\tA\t192.168.1.20"  >> /etc/bind/db.lan-directa.local
            echo -e "windowsserver\tIN\tA\t192.168.1.30"  >> /etc/bind/db.lan-directa.local
            echo -e "windowsdesktop\tIN\tA\t192.168.1.40" >> /etc/bind/db.lan-directa.local
  
          # Linkear zona LAN directa a /etc/bind/named.conf.local
            echo ""
            echo "Linkeando zona LAN directa a /etc/bind/named.conf.local..."
            echo ""
            echo 'zone "lan.local" {'                       >> /etc/bind/named.conf.local
            echo "  type master;"                           >> /etc/bind/named.conf.local
            echo '  file "/etc/bind/db.lan-directa.local";' >> /etc/bind/named.conf.local
            echo "};"                                       >> /etc/bind/named.conf.local

          # Comprobar la LAN zona directa
            echo ""
            echo "  Comprobando la zona directa..."
            echo ""
            named-checkzone lan.local /etc/bind/db.lan-directa.local


          # Crear y popular zona LAN inversa...
            echo ""
            echo "Creando y populando la base de datos de de la zona LAN inversa..."
            echo ""
            cp /etc/bind/db.127 /etc/bind/db.lan-inversa.local
            echo -e "10.1\tIN\tPTR\tubuntuserver.lan.local."   >> /etc/bind/db.lan-inversa.local
            echo -e "20.1\tIN\tPTR\tubuntudesktop.lan.local."  >> /etc/bind/db.lan-inversa.local
            echo -e "30.1\tIN\tPTR\twindowsserver.lan.local."  >> /etc/bind/db.lan-inversa.local
            echo -e "40.1\tIN\tPTR\twindowsdesktop.lan.local." >> /etc/bind/db.lan-inversa.local
            sed -i -e 's|@\tIN\tSOA\tlocalhost.\troot.localhost.|@\tIN\tSOA\tlan.local.\troot.lan.local.|g' /etc/bind/db.lan-inversa.local
            
            sed -i -e 's-localhost.lan.local.-g' /etc/bind/db.lan-inversa.local
                        
            sed -i -e 's-localhost.lan.local.-g' /etc/bind/db.lan-inversa.local

; BIND reverse data file for local loopback interface
;
$TTL 604800
@ IN SOA midominio.es. root.midominio.es. (
1002 ; Serial
604800 ; Refresh
86400 ; Retry
2419200 ; Expire
604800 ) ; Negative Cache TTL
;
@ IN NS ns.midominio.es.
1 IN PTR ns.midominio.es.







          # Linkear zona LAN inversa a /etc/bind/named.conf.local
            echo ""
            echo "Linkeando zona LAN inversa a /etc/bind/named.conf.local..."
            echo ""
            echo 'zone "lan.local" {'                       >> /etc/bind/named.conf.local
            echo "  type master;"                           >> /etc/bind/named.conf.local
            echo '  file "/etc/bind/db.lan-inversa.local";' >> /etc/bind/named.conf.local
            echo "};"                                       >> /etc/bind/named.conf.local

          # Comprobar la LAN zona inversa
            echo ""
            echo "  Comprobando la zona inversa..."
            echo ""
            named-checkzone 1.168.192.in-addr-arpa /etc/bind/db.lan-inversa.local

zone "128.10.in-addr.arpa

          # Coregir errores IPv6
            echo ""
            echo "Corrigiendo los posibles errores de IPv6..."
            echo ""
            sed -i -e 's|RESOLVCONF=no|RESOLVCONF=yes|g'           /etc/default/named
            sed -i -e 's|OPTIONS="-u bind"|OPTIONS="-4 -u bind"|g' /etc/default/named

          # Reiniciar servidor DNS
            echo ""
            echo "Reiniciando el servidor DNS..."
            echo ""
            service bind9 restart

          # Mostrar estado del servidor
            echo ""
            echo "Mostrando el estado del servidor DNS..."
            echo ""
            service bind9 status

        ;;

        3)

          echo ""
          echo "  Instalando el servidor DNS esclavo..."
          echo ""

        ;;

      esac

  done

fi
