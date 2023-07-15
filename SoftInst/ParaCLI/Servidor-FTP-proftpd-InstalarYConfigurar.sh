#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar proftpd en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-FTP-proftpd-InstalarYConfigurar.sh | bash
# ----------

cColorAzul="\033[0;34m"
cColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    exit
  fi

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

if [ $cVerSO == "7" ]; then

  echo ""
  echo -e "${cColorAzulClaro}Iniciando el script de instalación de proftpd para Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}Iniciando el script de instalación de proftpd para Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}Iniciando el script de instalación de proftpd para Debian 9 (Stretch)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}Iniciando el script de instalación de proftpd para Debian 10 (Buster)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}Iniciando el script de instalación de proftpd para Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update && apt-get -y install dialog
      echo ""
    fi

#  menu=(dialog --timeout 5 --checklist "Marca las opciones que quieras instalar:" 22 80 16)
  menu=(dialog --checklist "Marca las opciones que quieras instalar:" 18 64 14)
    opciones=(
      1 "Instalar servidor FTP básico." on
      2 "Modificar mensaje de bienvenida." off
      3 "Activar navegación anónima." off
      4 "Activar el logueo para los usuarios del sistema." off
      5 "Activar el enjaulado de usuarios." off
      6 "Desenjaular el usuario 1000." off
      7 "Desenjaular usuario específico." off
      8 "Activar la conexión mediante TLS." off
      9 "Activar permiso de escritura" off
     10 "Cambiar la ubicación de la carpeta pública" off
     11 "Permitir ls recursivo" off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

  for choice in $choices
    do
      case $choice in

        1)

          echo ""
          echo "  Instalando servidor FTP básico..."          echo ""

          echo ""
          echo "    Actualizando la lista de los paquetes disponibles en los repositorios..."          echo ""
          apt-get -y update

          echo ""
          echo "    Instalando el paquete proftpd..."          echo ""
          apt-get -y install proftpd
          touch /etc/proftpd/conf.d/extra.conf

        ;;

        2)

          echo ""
          echo "  Modificando mensaje de bienvenida..."          echo ""
          
          echo 'ServerIdent on "Bienvenido al servidor FTP."' >> /etc/proftpd/conf.d/extra.conf
          systemctl restart proftpd

        ;;

        3)

          echo ""
          echo "  Activando navegación anónima..."          echo ""

          echo ''                                                                                                      >> /etc/proftpd/conf.d/extra.conf
          echo '<Anonymous ~ftp>'                                                                                      >> /etc/proftpd/conf.d/extra.conf
          echo '   User ftp'                                                                                           >> /etc/proftpd/conf.d/extra.conf
          echo '   Group nogroup'                                                                                      >> /etc/proftpd/conf.d/extra.conf
          echo '   # Permitir a los clientes loguearse con la cuenta "anonymous" además de la de "ftp"'                >> /etc/proftpd/conf.d/extra.conf
          echo '     UserAlias anonymous ftp'                                                                          >> /etc/proftpd/conf.d/extra.conf
          echo '   # Que todos los archivos pertenezcan al usuario ftp'                                                >> /etc/proftpd/conf.d/extra.conf
          echo '     DirFakeUser on ftp'                                                                               >> /etc/proftpd/conf.d/extra.conf
          echo '     DirFakeGroup on ftp'                                                                              >> /etc/proftpd/conf.d/extra.conf
          echo '   # No requerir que los usuario tengan un shell válido en /etc/shells para poder loguearse'           >> /etc/proftpd/conf.d/extra.conf
          echo '    RequireValidShell off'                                                                             >> /etc/proftpd/conf.d/extra.conf
          echo '   # Limit la cantidad de usuarios anónimos conectados al mismo tiempo'                                >> /etc/proftpd/conf.d/extra.conf
          echo '     MaxClients 10'                                                                                    >> /etc/proftpd/conf.d/extra.conf
          echo '   # Mostrar un mensaje al login'                                                                      >> /etc/proftpd/conf.d/extra.conf
          echo '     DisplayLogin welcome.msg'                                                                         >> /etc/proftpd/conf.d/extra.conf
          echo '   # Mostrar un mensaje con cada cambio de directorio'                                                 >> /etc/proftpd/conf.d/extra.conf
          echo '     DisplayChdir .message'                                                                            >> /etc/proftpd/conf.d/extra.conf
          echo '   # No permitir el permiso de escritura en la carpta por defecto: (/srv/ftp/)'                        >> /etc/proftpd/conf.d/extra.conf
          echo '     <Directory *>'                                                                                    >> /etc/proftpd/conf.d/extra.conf
          echo '       <Limit WRITE>'                                                                                  >> /etc/proftpd/conf.d/extra.conf
          echo '         DenyAll'                                                                                      >> /etc/proftpd/conf.d/extra.conf
          echo '       </Limit>'                                                                                       >> /etc/proftpd/conf.d/extra.conf
          echo '     </Directory>'                                                                                     >> /etc/proftpd/conf.d/extra.conf
          echo '</Anonymous>'                                                                                          >> /etc/proftpd/conf.d/extra.conf
          echo ''                                                                                                      >> /etc/proftpd/conf.d/extra.conf
          systemctl restart proftpd

        ;;

        4)

          echo ""
          echo "  Activando el logueo para usuarios del sistema..."          echo ""

          echo ""
          echo "    En proftpd, la configuración por defecto ya permite loguearse por ftp a los usuarios del sistema!"
          echo ""

        ;;

        5)

          echo ""
          echo "  Activando enjaulado de usuarios..."          echo ""

          echo "DefaultRoot ~ !ftpsinjaula" >> /etc/proftpd/conf.d/extra.conf
          groupadd ftpsinjaula 2> /dev/null
          systemctl restart proftpd
          vEnjaulado="Activo"
 
        ;;

        6)

          echo ""
          echo "  Desenjaulando el usuario 1000..."          echo ""
          if [ "$vEnjaulado" = "Activo" ]; then
            vUsuario1000=$(cat /etc/passwd | grep "1000:1000" | cut -d ':' -f1)
            if [ "$vUsuario1000" = "" ]; then
              echo ""
              echo -e "${cColorRojo}    El usuario 1000 no existe. No se procederá con el desenjaulado.${cFinColor}"
              echo ""
            else
              vUsuarioLibre=$(id -nu 1000) 
              echo "    Se desenjaulará al usuario $vUsuarioLibre."
              echo '    Si se desea desenjaular a un usuario diferente habrá que agregarlo al grupo "ftpsinjaula"'
              echo ""
              usermod -a -G ftpsinjaula $vUsuarioLibre
              systemctl restart proftpd
            fi
          else
            echo ""
            echo -e "${cColorRojo}    No se procederá con el desenjaulado de ningún usuario porque el enjaulado no se ha activado previamente.${cFinColor}"
            echo ""
          fi

        ;;

        7)

          echo ""
          echo "  Desenjaulando usuario específico..."          echo ""
          if [ "$vEnjaulado" = "Activo" ]; then
            #read -p "Ingresa el nombre del usuario que quieras desenjaular: " vUsuarioLibre
            echo "    Ingresa el nombre del usuario que quieras desenjaular:"
            read vUsuarioALiberar < /dev/tty
            vUsuarioExiste=$(cat /etc/passwd | grep $vUsuarioALiberar | cut -d ':' -f1)
            if [ "$vUsuarioExiste" = "" ]; then
              echo ""
              echo -e "${cColorRojo}    El usuario $vUsuarioALiberar no existe. No se procederá con el desenjaulado.${cFinColor}"
              echo ""
            else
              echo "    Se desenjaulará al usuario $vUsuarioALiberar."
              echo '    Si se desea desenjaular a un usuario diferente habrá que agregarlo al grupo "ftpsinjaula"'
              echo ""
              usermod -a -G ftpsinjaula $vUsuarioALiberar
              systemctl restart proftpd
            fi
          else
            echo ""
            echo -e "${cColorRojo}    No se procederá con el desenjaulado de ningún usuario porque el enjaulado no se ha activado previamente.${cFinColor}"
            echo ""
          fi

        ;;

        8)

          echo ""
          echo "  Activando conexión mediante TLS..."          echo ""
          # Instalar el módulo para TLS
            apt-get -y install proftpd-mod-crypto
          # Activar el módulo
            sed -i -e 's|#LoadModule mod_tls.c|LoadModule mod_tls.c|g' /etc/proftpd/modules.conf
          # Generar el nuevo certificado
            rm -f /etc/ssl/certs/proftpd.crt 2> /dev/null
            rm -f /etc/ssl/private/proftpd.key 2> /dev/null
            #proftpd-gencert
            openssl req -x509 -nodes -newkey rsa:2048 -days 365 -keyout /etc/ssl/private/proftpd.key -out /etc/ssl/certs/proftpd.crt -subj "/C=ES/ST=Madrid/L=Arganda/O=MiEmpresa/CN=dominio.com/emailAddress=mail@gmail.com"
            chmod 600 /etc/ssl/private/proftpd.key
          # Modificar la configuración de TLS
            sed -i -e 's|#TLSEngine|\nTLSEngine|g'                                    /etc/proftpd/tls.conf
            sed -i -e 's|#TLSLog|\nTLSLog|g'                                          /etc/proftpd/tls.conf
            sed -i -e 's|#TLSProtocol|\nTLSProtocol|g'                                /etc/proftpd/tls.conf
            sed -i -e 's|#TLSRSACertificateFile|\nTLSRSACertificateFile|g'            /etc/proftpd/tls.conf
            sed -i -e 's|#TLSRSACertificateKeyFile|\nTLSRSACertificateKeyFile|g'      /etc/proftpd/tls.conf
          # Aceptar sólo conexiones seguras
            sed -i -e 's|#TLSRequired|\nTLSRequired|g'                              /etc/proftpd/tls.conf
          # Aceptar conexiones seguras e inseguras
            #sed -i -e 's|#TLSRequired.*|\nTLSRequired off|g'                       /etc/proftpd/tls.conf
          # Linkear TLS a la configuración general
            echo "Include /etc/proftpd/tls.conf" >> /etc/proftpd/conf.d/extra.conf
          # Reiniciar el servicio
            systemctl restart proftpd

        ;;

        9)

          echo ""
          echo "  Activando permiso de escritura..."          echo ""

          echo ""
          echo "    En proftpd, la configuración por defecto ya permite el permiso de escritura a los distintos usuarios del sistema!"
          echo "    Si lo que quieres es permitir permisos de escritura para usuarios anónimos, reemplaza:"
          echo ''
          echo '      <Directory *>'
          echo '        <Limit WRITE>'
          echo -e "${cColorRojo}          DenyAll${cFinColor}"
          echo '        </Limit>'
          echo '      </Directory>'
          echo ''
          echo '    por:'
          echo ''
          echo '      <Directory *>'
          echo '        <Limit WRITE>'
          echo -e "${cColorVerde}          AllowAll${cFinColor}"
          echo '        </Limit>'
          echo '      </Directory>'
          echo ''
          echo "    ...en el archivo:"
          echo ''
          echo "      /etc/proftpd/conf.d/extra.conf"
          echo ''
          echo "    ...y reinicia el servicio, ejecutando como root:"
          echo ''
          echo "      systemctl restart proftpd"
          echo ""

        ;;

       10)

          echo ""
          echo "  Cambiando la ubicación de la carpeta pública..."          echo ""

          echo "    Comandos todavía no preparados..."
        ;;

       11)

          echo ""
          echo "  Permitiendo ls recursivo..."          echo ""

          echo "    Comandos todavía no preparados..."
        ;;
          
    esac

  done

fi

