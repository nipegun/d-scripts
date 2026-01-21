#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar MariaDB en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/Servidor-BBDD-MariaDB-InstalarYConfigurar.sh | bash
#
# Ejecución remota como root (para permisos sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/Servidor-BBDD-MariaDB-InstalarYConfigurar.sh | sed 's-sudo--g'| bash
# ----------

vMariaDBRootPass='P@ssw0rd'

# Definir las variables de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  cFinColor='\033[0m'
 
# Registrar la fecha de ejecución del script
  vFecha=$(date +a%Ym%md%d@%T)

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
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de MariaDB para Debian 13 (Trixie)...${cFinColor}"
  echo ""

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install dialog
      echo ""
    fi

  menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
    opciones=(
      1 "Instalar paquete mariadb-server."                                on
      2 "Permitir conexiones desde todas las IPs (no sólo localhost)."    off
      3 "Permitir conexión SÓLO desde una IP específica (sin localhost)." off
      4 "Instalar phpmyadmin."                                            off
      5 "Securizar instalación con script oficial."                       off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

  for choice in $choices
    do
      case $choice in

        1)

          # Instalar el paquete mmariadb-server
            echo ""
            echo "  Instalando el paquete mariadb-server..."
            echo ""
            sudo apt-get -y update
            sudo apt-get -y install mariadb-server

        ;;

        2)

          # Permitir la conexión desde todas las IPs
            echo ""
            echo "  Permitiendo conexión desde todas las IPs (no sólo desde localhost)..."
            echo ""
            vExisteSec=$(sudo cat /etc/mysql/my.cnf | grep ^'\[mysqld]')
            if [[ $vExisteSec == "" ]]; then
              sudo cp /etc/mysql/my.cnf /etc/mysql/my.cnf.bak-$vFecha
              echo "[mysqld]"               | sudo tee -a /etc/mysql/my.cnf
              echo "bind-address = 0.0.0.0" | sudo tee -a /etc/mysql/my.cnf
              sudo systemctl restart mariadb
            else
              sudo cp /etc/mysql/my.cnf /etc/mysql/my.cnf.bak-$vFecha
              sudo sed -i -e 's|\[mysqld]|\[mysqld]\nbind-address = 0.0.0.0|g' /etc/mysql/my.cnf
              sudo systemctl restart mariadb
            fi

        ;;

        3)

          # Permitir conexiones sólo desde una IP específica
            echo ""
            echo "  Permitiendo conexión SÓLO desde una IP específica (sin localhost)..."
            echo ""
            echo "    Introduce la IP desde la que se deberían escuchar las conexiones y presiona Enter:"
            echo ""
            sudo read vIPExtra < /dev/tty
            echo ""
            vExisteSec=$(sudo cat /etc/mysql/my.cnf | grep ^'\[mysqld]')
            if [[ $vExisteSec == "" ]]; then
              sudo cp /etc/mysql/my.cnf /etc/mysql/my.cnf.bak-$vFecha
              echo "[mysqld]"                 | sudo tee -a /etc/mysql/my.cnf
              echo "bind-address = $vIPExtra" | sudo tee -a /etc/mysql/my.cnf
              sudo systemctl restart mariadb
            else
              sudo cp /etc/mysql/my.cnf /etc/mysql/my.cnf.bak-$vFecha
              sudo sed -i -e 's|bind-address = 0.0.0.0||g'                       /etc/mysql/my.cnf
              sudo sed -i -e 's|\[mysqld]|\[mysqld]\nbind-address = $vIPExtra|g' /etc/mysql/my.cnf
              sudo systemctl restart mariadb
            fi

        ;;

        4)

          # Instalar phpmydmin
            echo ""
            echo "  Instalando phpmyadmin..."
            echo ""
            sudo apt-get -y install phpmyadmin

        ;;

        4)

          # Securizar la instalación
            echo ""
            echo "  Securizando instalación con script oficial..."
            echo ""
            sudo mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED VIA unix_socket OR mysql_native_password USING PASSWORD('"$vMariaDBRootPass"'); FLUSH PRIVILEGES;"
            sudo mariadb -u root -p"$vMariaDBRootPass" -e "DELETE FROM mysql.user WHERE user='';"
            sudo mariadb -u root -p"$vMariaDBRootPass" -e "DROP DATABASE IF EXISTS test;"
            sudo mariadb -u root -p"$vMariaDBRootPass" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';"
            sudo mariadb -u root -p"$vMariaDBRootPass" -e "FLUSH PRIVILEGES;"

        ;;

      esac

  done

elif [ $cVerSO == "12" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de MariaDB para Debian 12 (Bookworm)...${cFinColor}"
  echo ""

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update
      apt-get -y install dialog
      echo ""
    fi

  menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
    opciones=(
      1 "Instalar paquete mariadb-server." on
      2 "Permitir conexiones desde todas las IPs (no sólo localhost)." off
      3 "Permitir conexión SÓLO desde una IP específica (sin localhost)." off
      4 "Instalar phpmyadmin." off
      5 "Securizar instalación con script oficial." off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

  for choice in $choices
    do
      case $choice in

        1)

          # Instalar el paquete mmariadb-server
            echo ""
            echo "  Instalando el paquete mariadb-server..."
            echo ""
            apt-get -y update
            apt-get -y install mariadb-server

        ;;

        2)

          # Permitir la conexión desde todas las IPs
            echo ""
            echo "  Permitiendo conexión desde todas las IPs (no sólo desde localhost)..."
            echo ""
            vExisteSec=$(cat /etc/mysql/my.cnf | grep ^'\[mysqld]')
            if [[ $vExisteSec == "" ]]; then
              cp /etc/mysql/my.cnf /etc/mysql/my.cnf.bak-$vFecha
              echo "[mysqld]"               >> /etc/mysql/my.cnf
              echo "bind-address = 0.0.0.0" >> /etc/mysql/my.cnf
              systemctl restart mariadb
            else
              cp /etc/mysql/my.cnf /etc/mysql/my.cnf.bak-$vFecha
              sed -i -e 's|\[mysqld]|\[mysqld]\nbind-address = 0.0.0.0|g' /etc/mysql/my.cnf
              systemctl restart mariadb
            fi

        ;;

        3)

          # Permitir conexiones sólo desde una IP específica
            echo ""
            echo "  Permitiendo conexión SÓLO desde una IP específica (sin localhost)..."
            echo ""
            echo "    Introduce la IP desde la que se deberían escuchar las conexiones y presiona Enter:"
            echo ""
            read vIPExtra < /dev/tty
            echo ""
            vExisteSec=$(cat /etc/mysql/my.cnf | grep ^'\[mysqld]')
            if [[ $vExisteSec == "" ]]; then
              cp /etc/mysql/my.cnf /etc/mysql/my.cnf.bak-$vFecha
              echo "[mysqld]"                 >> /etc/mysql/my.cnf
              echo "bind-address = $vIPExtra" >> /etc/mysql/my.cnf
              systemctl restart mariadb
            else
              cp /etc/mysql/my.cnf /etc/mysql/my.cnf.bak-$vFecha
              sed -i -e 's|bind-address = 0.0.0.0||g'                       /etc/mysql/my.cnf
              sed -i -e 's|\[mysqld]|\[mysqld]\nbind-address = $vIPExtra|g' /etc/mysql/my.cnf
              systemctl restart mariadb
            fi

        ;;

        4)

          # Instalar phpmydmin
            echo ""
            echo "  Instalando phpmyadmin..."
            echo ""
            apt-get -y install phpmyadmin

        ;;

        4)

          # Securizar la instalación
            echo ""
            echo "  Securizando instalación con script oficial..."
            echo ""
            mysql_secure_installation

        ;;

      esac

  done

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de MariaDB para Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update
      apt-get -y install dialog
      echo ""
    fi

  menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
    opciones=(
      1 "Instalar paquete mariadb-server." on
      2 "Permitir conexiones desde todas las IPs (no sólo localhost)." off
      3 "Permitir conexión SÓLO desde una IP específica (sin localhost)." off
      4 "Instalar phpmyadmin." off
      5 "Securizar instalación con script oficial." off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

  for choice in $choices
    do
      case $choice in

        1)

          # Instalar el paquete mmariadb-server
            echo ""
            echo "  Instalando el paquete mariadb-server..."
            echo ""
            apt-get -y update
            apt-get -y install mariadb-server

        ;;

        2)

          # Permitir la conexión desde todas las IPs
            echo ""
            echo "  Permitiendo conexión desde todas las IPs (no sólo desde localhost)..."
            echo ""
            vExisteSec=$(cat /etc/mysql/my.cnf | grep ^'\[mysqld]')
            if [[ $vExisteSec == "" ]]; then
              vFecha=$(date +a%Ym%md%d@%T)
              cp /etc/mysql/my.cnf /etc/mysql/my.cnf.bak-$vFecha
              echo "[mysqld]"               >> /etc/mysql/my.cnf
              echo "bind-address = 0.0.0.0" >> /etc/mysql/my.cnf
              systemctl restart mariadb
            else
              vFecha=$(date +a%Ym%md%d@%T)
              cp /etc/mysql/my.cnf /etc/mysql/my.cnf.bak-$vFecha
              sed -i -e 's|\[mysqld]|\[mysqld]\nbind-address = 0.0.0.0|g' /etc/mysql/my.cnf
              systemctl restart mariadb
            fi

        ;;

        3)

          # Permitir conexiones sólo desde una IP específica
            echo ""
            echo "  Permitiendo conexión SÓLO desde una IP específica (sin localhost)..."
            echo ""
            echo "    Introduce la IP desde la que se deberían escuchar las conexiones y presiona Enter:"
            echo ""
            read vIPExtra < /dev/tty
            echo ""
            vExisteSec=$(cat /etc/mysql/my.cnf | grep ^'\[mysqld]')
            if [[ $vExisteSec == "" ]]; then
              vFecha=$(date +a%Ym%md%d@%T)
              cp /etc/mysql/my.cnf /etc/mysql/my.cnf.bak-$vFecha
              echo "[mysqld]"                 >> /etc/mysql/my.cnf
              echo "bind-address = $vIPExtra" >> /etc/mysql/my.cnf
              systemctl restart mariadb
            else
              vFecha=$(date +a%Ym%md%d@%T)
              cp /etc/mysql/my.cnf /etc/mysql/my.cnf.bak-$vFecha
              sed -i -e 's|bind-address = 0.0.0.0||g'                       /etc/mysql/my.cnf
              sed -i -e 's|\[mysqld]|\[mysqld]\nbind-address = $vIPExtra|g' /etc/mysql/my.cnf
              systemctl restart mariadb
            fi

        ;;

        4)

          # Instalar phpmydmin
            echo ""
            echo "  Instalando phpmyadmin..."
            echo ""
            apt-get -y install phpmyadmin

        ;;

        4)

          # Securizar la instalación
            echo ""
            echo "  Securizando instalación con script oficial..."
            echo ""
            mysql_secure_installation

        ;;

      esac

  done

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de MariaDB para Debian 10 (Buster)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de MariaDB para Debian 9 (Stretch)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de MariaDB para Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "7" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de MariaDB para Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

fi

