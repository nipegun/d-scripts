#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para crear nuevas webs de apache2 en /var/www
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/Apache2-NuevaVarWWW.sh | bash -s 'Extension' 'Dominio' 'Password'
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/Apache2-NuevaVarWWW.sh | sed 's-sudo--g' | bash -s 'Extension' 'Dominio' 'Password'
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/Apache2-NuevaVarWWW.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Definir la cantidad de argumentos esperados
  cCantArgsEsperados=3

# Comprobar que se hayan pasado la cantidad de argumentos esperados. Abortar el script si no.
  if [ $# -ne $cCantArgsEsperados ]
    then
      echo ""
      echo -e "${cColorRojo}  Mal uso del script. El uso correcto sería: ${cFinColor}"
      echo ""
      if [[ "$0" == "bash" ]]; then
        vNombreDelScript="script.sh"
      else
        vNombreDelScript="$0"
      fi
      echo "    $vNombreDelScript [ExtensionDelDominio] [Dominio] y [Password]"
      echo ""
      echo "  Ejemplo:"
      echo ""
      echo "    $vNombreDelScript '.org' 'unawebcualquiera' '12345678'"
      echo ""
      echo "  NOTA: El nombre de la Web también se utilizará como nombre de usuario MySQL."
      echo ""
      exit
  fi

# Definir constantes
  cPassBD="$3"
  cDominio="$2"
  cExt="$1"

# Comprobar si el nombre de usuario MySQL deseado tiene mas de 16 caracteres
  nombre_mysql_deseado="$cDominio"
  if [ ${#nombre_mysql_deseado} -gt 16 ]; then
    # Acortar nombre de usuario MySQL a 16 caracteres
      nombre_mysql_ok=`expr substr $nombre_mysql_deseado 1 16`
    # Advertir al usuario que se va a usar un nombre de usuario MySQL acortado
      clear
      echo ""
      echo "  Has intentado usar $nombre_mysql_deseado como nombre para el usuario"
      echo "  de la base de datos pero MySQL no admite nombres de usuario"
      echo "  de más de 16 caracteres. En su lugar se utilizará $nombre_mysql_ok"
      echo ""
  fi

# Crear el menú
  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install dialog
      echo ""
    fi
  menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 80 16)
    opciones=(
      1 "Crear las carpetas de la web"                         on
      2 "Crear y activar la configuración de la web en Apache" on
      3 "Mejorar la seguridad"                                 off
      4 "Crear la base de datos con su usuario"                off
      5 "Crear el certificado SSL de letsencrypt"              off
    )
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Creando las carpetas de la web..."
              echo ""
              sudo mkdir -p /var/www/"$cDominio""$cExt"/
              sudo mkdir -p /var/www/"$cDominio""$cExt"-logs/
              echo "WEB OK" | sudo tee /var/www/"$cDominio""$cExt"/index.html

            ;;

            2)

              echo ""
              echo "  Creando y activando la configuración de la web en Apache..."
              echo ""
              sudo cp /etc/apache2/sites-available/nuevawebvar.conf /etc/apache2/sites-available/"$cDominio""$cExt".conf
              sudo sed -i -e "s/nuevawebvar.com/"$cDominio""$cExt"/g" /etc/apache2/sites-available/"$cDominio""$cExt".conf 
              # Reparar permisos y propietario de la carpeta
                sudo chown www-data:www-data /var/www/"$cDominio""$cExt"/ -R
                sudo find /var/www/"$cDominio""$cExt"/ -type d -exec chmod 755 {} \;
                sudo find /var/www/"$cDominio""$cExt"/ -type f -exec chmod 644 {} \;
                sudo chown -v root:root /var/www
              # Activar sitio de apache
                sudo a2ensite "$cDominio""$cExt"
              # Iniciar el servicio
                sudo systemctl enable apache2 --now

            ;;

            3)

              echo ""
              echo "  Mejorando la seguridad..."
              echo ""
              # Crear el archivo .htaccess con algunas opciones
                echo "# BEGIN Medidas de seguridad"                                                 | sudo tee    /var/www/"$cDominio""$cExt"/.htaccess
                echo ""                                                                             | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "# Proteger .htaccess"                                                         | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "<FilesMatch \"^.*\\.([Hh][Tt][Aa])\">"                                        | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "  Require all denied"                                                         | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "</FilesMatch>"                                                                | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo ""                                                                             | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "# Deshabilitar indexado"                                                      | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "Options -Indexes"                                                             | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo ""                                                                             | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "# Bloquear IPs"                                                               | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "<Limit GET POST>"                                                             | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "  Require all granted"                                                        | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "  Require not ip 45.45.45.45"                                                 | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "</Limit>"                                                                     | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo ""                                                                             | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "# Proteger wp-config.php"                                                     | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "<Files wp-config.php>"                                                        | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "  Require all denied"                                                         | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "</Files>"                                                                     | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo ""                                                                             | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "<IfModule mod_rewrite.c>"                                                     | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "  RewriteEngine On"                                                           | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "  RewriteBase /"                                                              | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo ""                                                                             | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "  # Bloquear enumeración de autores"                                          | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "  RewriteCond %{QUERY_STRING} (^|&)author=\\d+ [NC]"                          | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "  RewriteRule .* - [F]"                                                       | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo ""                                                                             | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "  # Anti-hotlinking de imágenes"                                              | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "  RewriteCond %{HTTP_REFERER} !^$"                                            | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "  RewriteCond %{HTTP_REFERER} !^https\\?://(www\\.)?"$cDominio""$cExt"/ [NC]" | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "  RewriteCond %{HTTP_REFERER} !^https\\?://(www\\.)?google\\.com/ [NC]"       | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo '  RewriteRule \.(jpg|jpeg|png|gif)$ - [F,NC,L]'                               | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "</IfModule>"                                                                  | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo ""                                                                             | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "# Redirigir www a sin www"                                                    | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "<IfModule mod_rewrite.c>"                                                     | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "  RewriteEngine On"                                                           | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo '  RewriteCond %{HTTP_HOST} ^www\.(.+)$ [NC]'                                  | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "  RewriteRule ^ https://%1%{REQUEST_URI} [R=301,L]"                           | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "</IfModule>"                                                                  | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo ""                                                                             | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess
                echo "# END Medidas de seguridad"                                                   | sudo tee -a /var/www/"$cDominio""$cExt"/.htaccess


              # Proteger los logs para que sólo se puedan ver con la sesión en WordPress iniciada
                echo "RewriteEngine On"                                      | sudo tee    /var/www/"$cDominio""$cExt"-logs/.htaccess
                echo ""                                                      | sudo tee -a /var/www/"$cDominio""$cExt"-logs/.htaccess
                echo "# Bloquear acceso a logs sin sesión WordPress"         | sudo tee -a /var/www/"$cDominio""$cExt"-logs/.htaccess
                echo "RewriteCond %{HTTP_COOKIE} !wordpress_logged_in_ [NC]" | sudo tee -a /var/www/"$cDominio""$cExt"-logs/.htaccess
                echo 'RewriteRule \.log$ https://google.com/ [R=302,L]'      | sudo tee -a /var/www/"$cDominio""$cExt"-logs/.htaccess

              # Reparar permisos y propietario de la carpeta
                sudo chown www-data:www-data /var/www/"$cDominio""$cExt"/ -R
                sudo find /var/www/"$cDominio""$cExt"/ -type d -exec chmod 755 {} \;
                sudo find /var/www/"$cDominio""$cExt"/ -type f -exec chmod 644 {} \;
                sudo chown -v root:root /var/www
                sudo systemctl restart apache2

            ;;

            4)

              echo ""
              echo "  Creando la base de datos con su usuario..."
              echo ""
              sudo /root/scripts/d-scripts/ParaSoftware/MySQL-BaseDeDatos-Crear.sh "$cDominio" "$cDominio" "$cPassBD"

            ;;

            5)

              echo ""
              echo "   Creando el certificado SSL de letsencrypt..."
              echo ""

              # Operar dependiendo de la versión de debian detectada

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

                if [ $cVerSO == "13" ]; then

                  echo ""
                  echo -e "${cColorAzulClaro}  Iniciando el script de creación de nueva web de apache2 para Debian 13 (trixie)...${cFinColor}"
                  echo ""

                  # Permitir los puertos en el cortafuegos
                    sudo nft add table inet filter
                    sudo nft add chain inet filter input { type filter hook input priority 0 \; }
                    sudo nft add rule inet filter input tcp dport { 80, 443 } accept

                  sudo systemctl apache2 stop
                  sudo apt-get -y update
                  sudo apt-get -y install certbot
                  sudo apt-get -y install python3-certbot-apache
                  sudo certbot --apache -d "$cDominio""$cExt" -d www."$cDominio""$cExt"
                  sudo systemctl apache2 start

                elif [ $cVerSO == "12" ]; then

                  echo ""
                  echo -e "${cColorAzulClaro}  Iniciando el script de creación de nueva web de apache2 para Debian 12 (Bookworm)...${cFinColor}"
                  echo ""

                  echo ""
                  echo -e "${cColorRojo}    Comandos para Debian 12 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
                  echo ""

                elif [ $cVerSO == "11" ]; then

                  echo ""
                  echo -e "${cColorAzulClaro}  Iniciando el script de creación de nueva web de apache2 para Debian 11 (Bullseye)...${cFinColor}"
                  echo ""

                  echo ""
                  echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
                  echo ""

                elif [ $cVerSO == "10" ]; then

                  echo ""
                  echo -e "${cColorAzulClaro}  Iniciando el script de creación de nueva web de apache2 para Debian 10 (Buster)...${cFinColor}"
                  echo ""

                  # Permitir los puertos en el cortafuegos
                    sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
                    sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT

                  sudo systemctl apache2 stop
                  sudo apt-get -y update
                  sudo apt-get -y install certbot
                  sudo apt-get -y install python3-certbot-apache
                  sudo certbot --apache -d "$cDominio""$cExt" -d www."$cDominio""$cExt"
                  sudo systemctl apache2 start

                elif [ $cVerSO == "9" ]; then

                  echo ""
                  echo -e "${cColorAzulClaro}  Iniciando el script de creación de nueva web de apache2 para Debian 9 (Stretch)...${cFinColor}"
                  echo ""

                  echo ""
                  echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
                  echo ""

                elif [ $cVerSO == "8" ]; then

                  echo ""
                  echo -e "${cColorAzulClaro}  Iniciando el script de creación de nueva web de apache2 para Debian 8 (Jessie)...${cFinColor}"
                  echo ""

                  echo ""
                  echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
                  echo ""

                elif [ $cVerSO == "7" ]; then

                  echo ""
                  echo -e "${cColorAzulClaro}  Iniciando el script de creación de nueva web de apache2 para Debian 7 (Wheezy)...${cFinColor}"
                  echo ""

                  echo ""
                  echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
                  echo ""

                fi

            ;;

        esac

    done

