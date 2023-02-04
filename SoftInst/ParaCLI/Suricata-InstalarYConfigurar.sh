#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar y configurar suricata en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Suricata-InstalarYConfigurar.sh | bash
#
#  Ejecución remota sin caché:
#  curl -s -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Suricata-InstalarYConfigurar.sh | bash
#
#  Ejecución remota con parámetros:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Suricata-InstalarYConfigurar.sh | bash -s Parámetro1 Parámetro2
# ----------

vColorAzul="\033[0;34m"
vColorAzulClaro="\033[1;34m"
vColorVerde='\033[1;32m'
vColorRojo='\033[1;31m'
vFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${vColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${vFinColor}" >&2
    exit 1
  fi

# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${vColorRojo}  curl no está instalado. Iniciando su instalación...${vFinColor}"
    echo ""
    apt-get -y update
    apt-get -y install curl
    echo ""
  fi

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    OS_NAME=$NAME
    OS_VERS=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    OS_NAME=$(lsb_release -si)
    OS_VERS=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    OS_NAME=$DISTRIB_ID
    OS_VERS=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    OS_NAME=Debian
    OS_VERS=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    OS_NAME=$(uname -s)
    OS_VERS=$(uname -r)
  fi

if [ $OS_VERS == "7" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación y configuración de suricata para Debian 7 (Wheezy)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación y configuración de suricata para Debian 8 (Jessie)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación y configuración de suricata para Debian 9 (Stretch)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación y configuración de suricata para Debian 10 (Buster)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación y configuración de suricata para Debian 11 (Bullseye)...${vFinColor}"
  echo ""

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${vColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${vFinColor}"
      echo ""
      apt-get -y update
      apt-get -y install dialog
      echo ""
    fi

  menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
    opciones=(
      1 "Instalar paquete Suricata, dependencias y otros paquetes útiles." oon
      2 "Configurar para un Debian con una única interfaz de red." off
      3 "Configurar para un Debian en modo router (con, al menos, dos interfaces de red)." off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "  Instalando paquete Suricata, dependencias y otros paquetes útiles..."
            echo ""

            # Actualizar el sistema
              apt-get -y update
            # Instalar suricata
              apt-get -y install suricata
            # Instalar paquetes extra
              apt-get -y install jq

          ;;

          2)

            echo ""
            echo "  Configurando para un Debian con una única interfaz de red..."
            echo ""

            # Determinar las interfaces activas que tienen asignada una IP
              aInterfacesActivasConIP=($(/root/scripts/d-scripts/Red-Interfaces-Activas-ConIPAsignada.sh | grep "→" | cut -d ':' -f2))
            # Comprobar si efectivamente hay una única interfaz de red
              if [ $(echo ${#aInterfacesActivasConIP[@]}) == "1" ]; then
                # Detener el servicio
                  echo ""
                  echo "    Deteniendo el servicio suricata..."
                  echo ""
                  systemctl stop suricata
                # Configurar
                  echo ""
                  echo "    Modificando archivos de confguración..."
                  echo ""
                  # Indicar la interfaz sobre la que va a correr
                    echo ""
                    echo "      Se ha encontrado una única interfaz activa con IP asignada: ${aInterfacesActivasConIP[0]}"
                    echo "      Se configurará como interfaz por defecto."
                    echo ""
                    # Buscar una línea que empiece por "af-packet:" y ejecutar el reemplazo en la siguiente línea
                      # Reemplazar sólo texto coincidente de la siguiente línea
                        #sed -i "/^af-packet:/{ n; s|- interface: eth0|- interface: ${aInterfacesActivasConIP[0]}|g }" /etc/suricata/suricata.yaml
                      # Reemplazar toda la siguiente línea
                        sed -i "/^af-packet:/{ n; s|- interface:.*|- interface: ${aInterfacesActivasConIP[0]}|g }" /etc/suricata/suricata.yaml
                  # Indicar las redes que van a ser consideradas como home
                    # Detectar si la IP es de clase A, B o C es una IP privada o una Pública
                      vClaseIP="c"
                      if [ $vClaseIP == "a"  ]; then
                        sed -i -e 's|HOME_NET: "\[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12]"|#HOME_NET: "\[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12]"|g' /etc/suricata/suricata.yaml
                        sed -i -e 's|#HOME_NET: "\[10.0.0.0/8]"|HOME_NET: "\[10.0.0.0/8]"|g'                                                           /etc/suricata/suricata.yaml
                      elif [ $vClaseIP == "b"  ]; then
                        sed -i -e 's|HOME_NET: "\[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12]"|#HOME_NET: "\[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12]"|g' /etc/suricata/suricata.yaml
                        sed -i -e 's|#HOME_NET: "\[172.16.0.0/12]"|HOME_NET: "\[172.16.0.0/12]"|g'                                                     /etc/suricata/suricata.yaml
                      elif [ $vClaseIP == "c"  ]; then
                        sed -i -e 's|HOME_NET: "\[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12]"|#HOME_NET: "\[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12]"|g' /etc/suricata/suricata.yaml
                        sed -i -e 's|#HOME_NET: "\[192.168.0.0/16]"|HOME_NET: "\[192.168.0.0/16]"|g'                                                   /etc/suricata/suricata.yaml
                      else
                        echo "      No se ha podido determinar de que clase es la IP de la interfaz"
                      fi
                # Crear reglas básica
                  echo ""
                  echo "    Creando reglas básicas..."
                  echo ""
                  touch /etc/suricata/rules/suricata.rules
                  # Registrar quién nos hace ping
                    echo 'alert icmp any any -> any any (msg: "Detectado paquete ICMP"; sid:2000001; rev:1;)'                                  >> /etc/suricata/rules/suricata.rules
                  # Detectar conexiones que en la carga útil (payload) detecten la palabra "facebook" (Sólo vale para http)
                    # curl -i facebook.com debería hacer saltar la alerta (incluso facebook.es debería hacerla saltar)
                    echo 'drop tcp any any -> any any (msg: "Detectado intento de acceso a Facebook"; content:"facebook"; sid:2000002; rev:1;)' >> /etc/suricata/rules/suricata.rules
                  # Hacer saltar la alerta de todas las salidas http en el puerto 80
                    echo 'alert http $HOME_NET any -> $EXTERNAL_NET 80 (msg: "Detectada petición GET HTML"; flow:established,to_server; content:"GET"; http_method; sid:2000003; rev:1;)' >> /etc/suricata/rules/suricata.rules
                  # Alerta de conexiones SSH en el puerto 22
                    echo 'alert ssh any any -> any any (msg: "Detectado intento de conexión SSH entrante"; sid:2000004; rev:1;)' >> /etc/suricata/rules/suricata.rules
                  # Alerta de escaneo de puertos
                    echo 'alert tcp any any -> any any (msg: "Detectado intento NMAP Scan FIN"; flags:F; sid:2000005; rev:1;)'         >> /etc/suricata/rules/suricata.rules
                    echo 'alert tcp any any -> any any (msg: "Detectado intento NMAP Scan NULL"; flags:0; sid:2000006; rev:1;)'        >> /etc/suricata/rules/suricata.rules
                    echo 'alert tcp any any -> any any (msg: "Detectado intento NMAP Scan XMAS Tree"; flags:FPU; sid:2000008; rev:1;)' >> /etc/suricata/rules/suricata.rules
                    echo 'alert icmp any any -> any any (msg: "Detectado intento NMAP Scan Ping Sweep"; dsize:0; sid:2000010; rev:1;)'  >> /etc/suricata/rules/suricata.rules
                    # Estos escaneos deberían hacerlo saltar:
                      # nmap -sU 192.168.1.x ("Detectado intento NMAP Scan UDP")
                      # nmap 192.168.1.x     ("Detectado intento NMAP Scan TCP")
                  # Puertos entrantes
                    echo 'alert icmp $EXTERNAL_NET any -> $HOME_NET any (msg: "Detectado paquete saliente ICMP"; sid:3000001; rev:1;)'                >> /etc/suricata/rules/debian-in.rules
                    echo 'alert tcp $EXTERNAL_NET any -> $HOME_NET 22 (msg: "Detectado paquete entrante hacia puerto 22 tcp"; sid:3000022; rev:1;)'   >> /etc/suricata/rules/debian-in.rules
                    echo 'alert udp $EXTERNAL_NET any -> $HOME_NET 53 (msg: "Detectado paquete entrante hacia puerto 53 udp"; sid:3000053; rev:1;)'   >> /etc/suricata/rules/debian-in.rules
                    echo 'alert tcp $EXTERNAL_NET any -> $HOME_NET 80 (msg: "Detectado paquete entrante hacia puerto 80 tcp"; sid:3000080; rev:1;)'   >> /etc/suricata/rules/debian-in.rules
                    echo 'alert tcp $EXTERNAL_NET any -> $HOME_NET 443 (msg: "Detectado paquete entrante hacia puerto 443 tcp"; sid:3000443; rev:1;)' >> /etc/suricata/rules/debian-in.rules
                  # Puertos salientes
                    echo 'alert icmp $HOME_NET any -> $EXTERNAL_NET any (msg: "Detectado paquete saliente ICMP"; sid:4000001; rev:1;)'                >> /etc/suricata/rules/debian-out.rules
                    echo 'alert tcp $HOME_NET any -> $EXTERNAL_NET 22 (msg: "Detectado paquete saliente hacia puerto 22 tcp"; sid:4000022; rev:1;)'   >> /etc/suricata/rules/debian-out.rules
                    echo 'alert udp $HOME_NET any -> $EXTERNAL_NET 53 (msg: "Detectado paquete saliente hacia puerto 53 udp"; sid:4000053; rev:1;)'   >> /etc/suricata/rules/debian-out.rules
                    echo 'alert tcp $HOME_NET any -> $EXTERNAL_NET 80 (msg: "Detectado paquete saliente hacia puerto 80 tcp"; sid:4000080; rev:1;)'   >> /etc/suricata/rules/debian-out.rules
                    echo 'alert tcp $HOME_NET any -> $EXTERNAL_NET 443 (msg: "Detectado paquete saliente hacia puerto 443 tcp"; sid:4000443; rev:1;)' >> /etc/suricata/rules/debian-out.rules
                  # Bloquear todas las conexiones entrantes no establecidas
                    echo 'alert icmp $EXTERNAL_NET any -> $HOME_NET any (msg: "Detectada conexión ICMP entrante no solicitada"; flow:not_established; sid:5000001; rev:1;)' >> /etc/suricata/rules/debian-cortafuegos.rule
                    echo 'alert tcp $EXTERNAL_NET any -> $HOME_NET any (msg: "Detectada conexión TCP entrante no solicitada"; flow:not_established; sid:5000002; rev:1;)' >> /etc/suricata/rules/debian-cortafuegos.rule
                    echo 'alert udp $EXTERNAL_NET any -> $HOME_NET any (msg: "Detectada conexión UDP entrante no solicitada"; flow:not_established; sid:5000003; rev:1;)' >> /etc/suricata/rules/debian-cortafuegos.rule

                  echo ""
                  echo "      Para ver las alertas en tiempo real, ejecuta:"
                  echo "        tail -f /var/log/suricata/fast.log"
                  echo ""
                # Iniciar el servicio
                  echo ""
                  echo "    Iniciando el servicio suricata..."
                  echo ""
                  systemctl start suricata
              elif [ $(echo ${#aInterfacesActivasConIP[@]}) == "" ]; then
                echo ""
                echo "  No se ha encontrado al menos una interfaz de red activa con IP asignada."
                echo "  No se configurará automáticmante la interfaz por defecto."
                echo "  Deberás configurarla manualmente editando el archivo /etc/suricata/suricata.yaml y cambiando"
                echo "    - interface: eth0"
                echo "  ...por la interfaz sobre la que quieres hacer correr suricata."
                echo ""
              else
                echo ""
                echo "  Se ha encontrad más de una interfaz red activa con IP asignada"
                echo "  No se configurará automáticmante la interfaz por defecto."
                echo "  Probablemente te interese volver a ejecutar el script y seleccionar la configuración"
                echo "  para Debian con más de una interfaz."
                echo ""
              fi

          ;;

          3)

            echo ""
            echo "  Configurando para un Debian en modo router (con, al menos, dos interfaces de red)."
            echo ""

                  # Indicar las redes que van a ser consideradas como home
                    # Detectar si la IP es de clase A, B o C es una IP privada o una Pública
                      vIPWAN="priv"
                      if [ $vIPWAN == "pub"  ]; then
                        sed -i -e 's|HOME_NET: "\[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12]"|#HOME_NET: "\[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12]"|g' /etc/suricata/suricata.yaml
                        sed -i -e 's|#HOME_NET: "\[192.168.0.0/16]"|HOME_NET: "\[192.168.0.0/16]"|g'                                                   /etc/suricata/suricata.yaml
                      elif [ $vIPWAN == "priv"  ]; then
                        vSubRedHomeNet="192.168.0.0/16"
                        sed -i -e 's|HOME_NET: "\[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12]"|#HOME_NET: "\[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12]"|g' /etc/suricata/suricata.yaml
                        sed -i -e 's|#HOME_NET: "\[192.168.0.0/16]"|HOME_NET: "\[$vSubRedHomeNet]"|g'                                                  /etc/suricata/suricata.yaml
                      fi

          ;;

          4)

            echo ""
            echo "  Actualizando la fuente de reglas..."
            echo ""
            suricata-update update-sources
            echo ""
            echo "  Hay disponibles para descargar reglas de estas fuentes:"
            echo ""
            suricata-update list-sources | grep Vendor
              # Para instalar reglas de un vendor:
              #suricata-update enable-source oisf/trafficid
              #suricata-update
            
            echo ""
            echo "  Metiendo todas las reglas disponibles dentro del archivo /var/lib/suricata/rules/suricata.rules..."
            echo ""
            suricata-update

To enable rules that are disabled by default, use /etc/suricata/enable.conf

2019401                   # enable signature with this sid
group:emerging-icmp.rules # enable this rulefile
re:trojan                 # enable all rules with this string

Similarly, to disable rules use /etc/suricata/disable.conf:

2019401                   # disable signature with this sid
group:emerging-info.rules # disable this rulefile
re:heartbleed             # disable all rules with this string

After updating these files, rerun suricata-update again:

sudo suricata-update


systemctl restart suricata
          ;;

      esac

  done
 
fi

