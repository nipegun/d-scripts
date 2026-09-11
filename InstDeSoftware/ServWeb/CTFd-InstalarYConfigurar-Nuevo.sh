#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar CTFd en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/CTFd-InstalarYConfigurar-Nuevo.sh | bash
#
# Ejecución remota como root (para permisos sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/CTFd-InstalarYConfigurar-Nuevo.sh | sed 's-sudo--g' | bash
#
# Enlace: https://github.com/CTFd/CTFd
# ----------
#
# Notas de esta versión:
#
#   - CTFd se instala SIEMPRE sobre MariaDB. Nunca sobre SQLite. La configuración de la base
#     de datos se pasa con los parámetros por separado (DATABASE_HOST, DATABASE_USER,
#     DATABASE_PASSWORD...) y no con DATABASE_URL, porque cualquier caracter raro en la
#     contraseña (una @, por ejemplo) rompería la URL y CTFd caería sin avisar a la SQLite de
#     CTFd/ctfd.db. Antes de inicializar la base de datos el script comprueba que la
#     configuración apunta de verdad a MariaDB y, si no, aborta.
#
#   - El servicio de systemd carga /opt/CTFd/.ctfd.env con EnvironmentFile. Sin esa línea,
#     CTFd no lee ese archivo por su cuenta y se ignoraría toda la configuración.
#
#   - gunicorn se lanza con workers gevent, no con los sync de serie. CTFd tiene el endpoint
#     /events (Server-Sent Events), al que cada navegador mantiene una conexión abierta de
#     forma permanente. Con workers sync cada una de esas conexiones bloquea un worker
#     entero, así que con 4 pestañas abiertas la web se queda colgada y gunicorn empieza a
#     matar y a relanzar workers en bucle con WORKER TIMEOUT. Además el propio código de CTFd
#     da por supuesto que se usa gevent (usa gevent.Timeout y gevent.spawn en
#     CTFd/utils/events/).
#
#   - Se instala Redis para la caché compartida entre workers y para el gestor de eventos.
#     Sin Redis, CTFd usa la carpeta .data como caché y una cola de eventos por cada worker,
#     con lo que las notificaciones sólo llegan a los clientes conectados a ese worker.
#
#   - El script funciona igual de las dos maneras que se indican arriba: tal cual (usando
#     sudo) o pasado por sed para quitarle esa palabra y ejecutarlo como root. Por eso no se
#     usa ninguna opción de sudo en todo el script (un "sudo -E", por ejemplo, se quedaría
#     convertido en un "-E" suelto y rompería el comando), y por eso la configuración la
#     carga el propio proceso hijo y no el script padre: al ejecutarse con sudo, sudo limpia
#     el entorno y las variables del padre no llegarían a flask db upgrade.
#
#   - Las contraseñas se generan aleatorias (sólo alfanuméricas, para que no rompan ninguna
#     URL ni ninguna sentencia SQL) y se guardan en /etc/ctfd-instalacion.conf, en modo 600.
#     La contraseña de root de MariaDB no se toca: en Debian root entra por unix_socket, o
#     sea con "sudo mariadb", que es más seguro que ponerle una contraseña fija y conocida.
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde="\033[1;32m"
  cColorRojo="\033[1;31m"
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor="\033[0m"

# Definir constantes de rutas
  cRutaCTFd="/opt/CTFd"
  cRutaEnv="/opt/CTFd/.ctfd.env"
  cRutaCredenciales="/etc/ctfd-instalacion.conf"

# Comprobar de qué manera se está ejecutando el script
#
# El script admite las dos formas de ejecución que aparecen arriba: tal cual, apoyándose en
# sudo, o pasándolo por sed para quitarle esa palabra y ejecutarlo directamente como root.
# La constante de la línea siguiente es la que delata en qué modo estamos: si el sed ha
# pasado por aquí, se queda vacía, y entonces el script tiene que estar corriendo ya como
# root o no podrá escribir nada.
  cComandoElevar="sudo"

  if [ -z "$cComandoElevar" ]; then
    if [ "$(id -u)" != "0" ]; then
      echo ""
      echo -e "${cColorRojo}  Al script se le han quitado los sudo, así que hay que ejecutarlo como root.${cFinColor}"
      echo -e "${cColorRojo}  Vuelve a lanzarlo como root, o sin quitarle los sudo.${cFinColor}"
      echo ""
      exit 1
    fi
  else
    if ! command -v sudo > /dev/null 2>&1; then
      echo ""
      echo -e "${cColorRojo}  Este script se apoya en sudo, pero sudo no está instalado.${cFinColor}"
      echo -e "${cColorRojo}  Ejecútalo como root con la variante que aparece comentada al principio${cFinColor}"
      echo -e "${cColorRojo}  de este mismo script, la que le quita esa palabra.${cFinColor}"
      echo ""
      exit 1
    fi
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

# Definir funciones auxiliares

  # Generar una contraseña aleatoria sólo con letras y números.
  # Se deja fuera cualquier otro caracter a propósito: una @ o unos : en la contraseña
  # rompen las URLs de conexión, y las comillas rompen las sentencias SQL.
    fnGenerarPass() {
      LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 32
    }

  # Cargar las credenciales de /etc/ctfd-instalacion.conf, o generarlas si es la primera vez.
  # Se guardan en un archivo para que las distintas opciones del menú usen las mismas, aunque
  # se ejecuten en momentos diferentes o en varias pasadas del script.
    fnCargarCredenciales() {

      if [ -f "$cRutaCredenciales" ]; then
        . <(sudo cat "$cRutaCredenciales")
      fi

      if [ -z "$vPassBDCTFd" ]; then
        vPassBDCTFd=$(fnGenerarPass)
      fi

      if [ -z "$vLlaveFlask" ]; then
        vLlaveFlask=$(python3 -c "import secrets; print(secrets.token_hex(32))" 2>/dev/null)
      fi

      if [ -z "$vLlaveFlask" ]; then
        vLlaveFlask=$(openssl rand -hex 32 2>/dev/null)
      fi

      echo "# Credenciales generadas por el script de instalación de CTFd."          | sudo tee    "$cRutaCredenciales" > /dev/null
      echo "# Archivo sólo para consulta. Quien manda es /opt/CTFd/.ctfd.env."       | sudo tee -a "$cRutaCredenciales" > /dev/null
      echo "vPassBDCTFd='$vPassBDCTFd'"                                             | sudo tee -a "$cRutaCredenciales" > /dev/null
      echo "vLlaveFlask='$vLlaveFlask'"                                             | sudo tee -a "$cRutaCredenciales" > /dev/null
      sudo chown root:root "$cRutaCredenciales"
      sudo chmod 600       "$cRutaCredenciales"

    }

  # Dejar los permisos como tienen que quedar.
  # El .ctfd.env lleva dentro la contraseña de la base de datos y la SECRET_KEY, así que no
  # puede quedar legible por todo el mundo: va root:ctfd y en modo 640. El resto de /opt/CTFd
  # sí es del usuario ctfd, que es el que ejecuta la aplicación.
    fnArreglarPermisos() {
      sudo chown -R ctfd:ctfd "$cRutaCTFd"
      if [ -f "$cRutaEnv" ]; then
        sudo chown root:ctfd "$cRutaEnv"
        sudo chmod 640       "$cRutaEnv"
      fi
    }

  # Comprobar que la configuración apunta a MariaDB y no a SQLite.
  # Es la condición exacta que mira CTFd/config.py: si DATABASE_URL está vacío y DATABASE_HOST
  # también, se va al final del if y usa la SQLite de CTFd/ctfd.db.
    fnComprobarQueNoEsSQLite() {

      if [ ! -f "$cRutaEnv" ]; then
        echo ""
        echo -e "${cColorRojo}    No existe $cRutaEnv. Ejecuta antes la opción de crear el archivo de configuración.${cFinColor}"
        echo ""
        return 1
      fi

      if ! sudo grep -qE "^DATABASE_HOST=.+" "$cRutaEnv"; then
        echo ""
        echo -e "${cColorRojo}    En $cRutaEnv no hay un DATABASE_HOST con valor.${cFinColor}"
        echo -e "${cColorRojo}    Sin él CTFd se iría a la SQLite de CTFd/ctfd.db. Se aborta.${cFinColor}"
        echo ""
        return 1
      fi

      if sudo grep -qE "^DATABASE_URL=" "$cRutaEnv"; then
        echo ""
        echo -e "${cColorRojo}    En $cRutaEnv hay un DATABASE_URL.${cFinColor}"
        echo -e "${cColorRojo}    Este script usa los parámetros por separado a propósito. Quítalo. Se aborta.${cFinColor}"
        echo ""
        return 1
      fi

      return 0

    }

# Ejecutar comandos dependiendo de la versión de Debian detectada

  if [ "$cVerSO" == "13" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de CTFd para Debian 13 (Trixie)...${cFinColor}"
    echo ""

    # Crear el menú
      # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install dialog
          echo ""
        fi
      menu=(dialog --checklist "Marca las opciones que quieras instalar:" 24 85 18)
        opciones=(
          1  "Instalar requerimientos de sistema"                            on
          2  "Crear el usuario que ejecutará la app"                         on
          3  "Clonar el repo de Github"                                      on
          4  "Crear la base de datos en MariaDB"                             on
          5  "Instalar y configurar Redis"                                   on
          6  "Crear el entorno virtual de python e instalar requerimientos"  on
          7  "Crear el archivo de configuración (.ctfd.env)"                 on
          8  "Inicializar la base de datos en MariaDB"                       on
          9  "Crear el servicio en systemd y arrancarlo"                     on
          10 "Instalar el proxy inverso con nginx"                           off
          11 "Instalar el proxy inverso con haproxy"                         off
          12 "Comprobar la instalación"                                      on
          13 "Mostrar mensaje de fin de instalación"                         on
        )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Instalando requerimientos de sistema..."
              echo ""
              sudo apt-get -y update
              sudo apt-get -y install python3
              sudo apt-get -y install python3-venv
              sudo apt-get -y install python3-pip
              sudo apt-get -y install git
              sudo apt-get -y install mariadb-server
              sudo apt-get -y install mariadb-client
              # No hace falta libmariadb-dev porque el conector que se usa es pymysql, que es
              # python puro. build-essential se deja porque alguna dependencia del
              # requirements.txt de CTFd puede necesitar compilarse si no hay wheel.
              sudo apt-get -y install build-essential

            ;;

            2)

              echo ""
              echo "  Creando el usuario que ejecutará la app..."
              echo ""

              # Crear el usuario antes de clonar el repo, para que el chown de después
              # encuentre un usuario que ya existe.
                if id ctfd > /dev/null 2>&1; then
                  echo "    El usuario ctfd ya existe. No se vuelve a crear."
                else
                  sudo useradd --system --no-create-home --shell /usr/sbin/nologin ctfd
                fi

            ;;

            3)

              echo ""
              echo "  Clonando el repo de Github..."
              echo ""

              cd /opt/
              sudo rm -rf "$cRutaCTFd"
              # Para clavar una versión concreta en lugar de master:
              #   sudo git clone --depth 1 --branch 3.8.6 https://github.com/CTFd/CTFd.git
              sudo git clone https://github.com/CTFd/CTFd.git
              fnArreglarPermisos

            ;;

            4)

              echo ""
              echo "  Creando la base de datos en MariaDB..."
              echo ""

              fnCargarCredenciales

              # La contraseña de root de MariaDB no se toca: en Debian root entra por
              # unix_socket, o sea con "sudo mariadb", sin contraseña.
              # La contraseña del usuario ctfd va por la entrada estándar y no como argumento,
              # para que no se quede a la vista de cualquiera en la salida de ps.
              # El juego de caracteres es utf8mb4 para que CTFd admita emojis en los nombres
              # de los equipos y de los retos.
                sudo mariadb <<SQL
CREATE DATABASE IF NOT EXISTS ctfd CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'ctfd'@'localhost' IDENTIFIED BY '$vPassBDCTFd';
CREATE USER IF NOT EXISTS 'ctfd'@'127.0.0.1' IDENTIFIED BY '$vPassBDCTFd';
ALTER USER 'ctfd'@'localhost' IDENTIFIED BY '$vPassBDCTFd';
ALTER USER 'ctfd'@'127.0.0.1' IDENTIFIED BY '$vPassBDCTFd';
GRANT ALL PRIVILEGES ON ctfd.* TO 'ctfd'@'localhost';
GRANT ALL PRIVILEGES ON ctfd.* TO 'ctfd'@'127.0.0.1';
FLUSH PRIVILEGES;
SQL

              sudo systemctl enable mariadb --now

              echo ""
              echo -e "${cColorVerde}    Base de datos ctfd creada. La contraseña está en $cRutaCredenciales${cFinColor}"
              echo ""

            ;;

            5)

              echo ""
              echo "  Instalando y configurando Redis..."
              echo ""

              sudo apt-get -y update
              sudo apt-get -y install redis-server

              # Ponerle un techo de memoria para que Redis no le quite la RAM a gunicorn y a
              # MariaDB. La caché de CTFd se puede reconstruir, así que se pueden desalojar
              # claves sin perder nada.
                if ! sudo grep -q "Ajustes para CTFd" /etc/redis/redis.conf; then
                  echo ""                                                              | sudo tee -a /etc/redis/redis.conf > /dev/null
                  echo "# --- Ajustes para CTFd ---"                                   | sudo tee -a /etc/redis/redis.conf > /dev/null
                  echo "# La cache de CTFd es reconstruible, asi que se pueden"        | sudo tee -a /etc/redis/redis.conf > /dev/null
                  echo "# desalojar claves antes que quedarse sin memoria."            | sudo tee -a /etc/redis/redis.conf > /dev/null
                  echo "maxmemory 256mb"                                               | sudo tee -a /etc/redis/redis.conf > /dev/null
                  echo "maxmemory-policy allkeys-lru"                                  | sudo tee -a /etc/redis/redis.conf > /dev/null
                else
                  echo "    Los ajustes para CTFd ya estaban en redis.conf. No se repiten."
                fi

              sudo systemctl enable redis-server --now
              sudo systemctl restart redis-server

              echo ""
              echo -n "    Respuesta de Redis: "
              redis-cli ping
              echo ""

            ;;

            6)

              echo ""
              echo "  Creando el entorno virtual de python e instalando requerimientos..."
              echo ""

              cd "$cRutaCTFd"
              sudo python3 -m venv venv

              # Crear el mensaje para mostrar cuando se entra al entorno virtual
                echo ''                                                                                                        | sudo tee -a "$cRutaCTFd"/venv/bin/activate > /dev/null
                echo 'echo -e "\n  Activando el entorno virtual de CTFd... \n"'                                                | sudo tee -a "$cRutaCTFd"/venv/bin/activate > /dev/null
                echo 'echo -e "    Forma de uso:\n"'                                                                           | sudo tee -a "$cRutaCTFd"/venv/bin/activate > /dev/null
                echo 'echo -e "      cd /opt/CTFd/ && flask run --host=0.0.0.0"'                                               | sudo tee -a "$cRutaCTFd"/venv/bin/activate > /dev/null
                echo 'echo -e "        o"'                                                                                     | sudo tee -a "$cRutaCTFd"/venv/bin/activate > /dev/null
                echo "echo -e \"      cd /opt/CTFd/ && gunicorn -w 4 -k gevent -b 0.0.0.0:4000 'CTFd:create_app()'\""          | sudo tee -a "$cRutaCTFd"/venv/bin/activate > /dev/null
                echo "echo -e ''"                                                                                              | sudo tee -a "$cRutaCTFd"/venv/bin/activate > /dev/null

              # Instalar los requerimientos.
              # No hace falta instalar nada a mano aparte: gunicorn, gevent, pymysql y redis
              # ya vienen todos en el requirements.txt de CTFd.
                sudo "$cRutaCTFd"/venv/bin/pip3 install --upgrade pip
                sudo "$cRutaCTFd"/venv/bin/pip3 install -r "$cRutaCTFd"/requirements.txt

              fnArreglarPermisos

              echo ""
              echo "    Comprobando que están los paquetes que hacen falta..."
              sudo "$cRutaCTFd"/venv/bin/pip3 list 2>/dev/null | grep -iE "^(gunicorn|gevent|pymysql|redis) "
              echo ""
              echo -e "${cColorVerde}    Entorno virtual preparado.${cFinColor}"
              echo ""

            ;;

            7)

              echo ""
              echo "  Creando el archivo de configuración de CTFd..."
              echo ""

              fnCargarCredenciales

              # Los parámetros de la base de datos van POR SEPARADO y nunca como DATABASE_URL.
              # Así SQLAlchemy escapa él solo la contraseña. Con DATABASE_URL, cualquier @ en
              # la contraseña partiría la URL en dos y CTFd se iría a la SQLite sin avisar.
                echo "# Configuración de CTFd."                                            | sudo tee    "$cRutaEnv" > /dev/null
                echo "# El servicio de systemd carga este archivo con EnvironmentFile, y"   | sudo tee -a "$cRutaEnv" > /dev/null
                echo "# CTFd aplica estas variables sobre los campos que estén vacíos en"   | sudo tee -a "$cRutaEnv" > /dev/null
                echo "# CTFd/config.ini. CTFd NO lee este archivo por su cuenta."           | sudo tee -a "$cRutaEnv" > /dev/null
                echo ""                                                                     | sudo tee -a "$cRutaEnv" > /dev/null
                echo "FLASK_ENV=production"                                                 | sudo tee -a "$cRutaEnv" > /dev/null
                echo ""                                                                     | sudo tee -a "$cRutaEnv" > /dev/null
                echo "# Base de datos MariaDB local."                                       | sudo tee -a "$cRutaEnv" > /dev/null
                echo "# Se indican los parámetros por separado en lugar de usar"            | sudo tee -a "$cRutaEnv" > /dev/null
                echo "# DATABASE_URL para que SQLAlchemy escape la contraseña. Si aquí no"   | sudo tee -a "$cRutaEnv" > /dev/null
                echo "# hubiera un DATABASE_HOST con valor, CTFd usaría la SQLite de"       | sudo tee -a "$cRutaEnv" > /dev/null
                echo "# CTFd/ctfd.db sin decir nada."                                       | sudo tee -a "$cRutaEnv" > /dev/null
                echo "DATABASE_PROTOCOL=mysql+pymysql"                                      | sudo tee -a "$cRutaEnv" > /dev/null
                echo "DATABASE_HOST=127.0.0.1"                                              | sudo tee -a "$cRutaEnv" > /dev/null
                echo "DATABASE_PORT=3306"                                                   | sudo tee -a "$cRutaEnv" > /dev/null
                echo "DATABASE_NAME=ctfd"                                                   | sudo tee -a "$cRutaEnv" > /dev/null
                echo "DATABASE_USER=ctfd"                                                   | sudo tee -a "$cRutaEnv" > /dev/null
                echo "DATABASE_PASSWORD=$vPassBDCTFd"                                       | sudo tee -a "$cRutaEnv" > /dev/null
                echo ""                                                                     | sudo tee -a "$cRutaEnv" > /dev/null
                echo "SECRET_KEY=$vLlaveFlask"                                              | sudo tee -a "$cRutaEnv" > /dev/null
                echo ""                                                                     | sudo tee -a "$cRutaEnv" > /dev/null
                echo "# Redis local: caché compartida entre los workers y gestor de los"    | sudo tee -a "$cRutaEnv" > /dev/null
                echo "# eventos (SSE). Al definir REDIS_URL, CTFd pone CACHE_TYPE=redis y"  | sudo tee -a "$cRutaEnv" > /dev/null
                echo "# usa RedisEventManager en lugar de una cola de eventos por worker."  | sudo tee -a "$cRutaEnv" > /dev/null
                echo "REDIS_URL=redis://127.0.0.1:6379/0"                                   | sudo tee -a "$cRutaEnv" > /dev/null
                echo ""                                                                     | sudo tee -a "$cRutaEnv" > /dev/null
                echo "# CTFd está detrás de un proxy inverso: debe fiarse de"               | sudo tee -a "$cRutaEnv" > /dev/null
                echo "# X-Forwarded-For, o registrará a todos los usuarios con la IP del"   | sudo tee -a "$cRutaEnv" > /dev/null
                echo "# proxy en lugar de la suya."                                         | sudo tee -a "$cRutaEnv" > /dev/null
                echo "REVERSE_PROXY=true"                                                   | sudo tee -a "$cRutaEnv" > /dev/null
                echo ""                                                                     | sudo tee -a "$cRutaEnv" > /dev/null
                echo "MAIL_SERVER=localhost"                                                | sudo tee -a "$cRutaEnv" > /dev/null
                echo "MAIL_PORT=25"                                                         | sudo tee -a "$cRutaEnv" > /dev/null
                echo "MAIL_USE_TLS=false"                                                   | sudo tee -a "$cRutaEnv" > /dev/null

              fnArreglarPermisos

              echo ""
              echo -e "${cColorVerde}    Configuración creada en $cRutaEnv (root:ctfd, modo 640).${cFinColor}"
              echo ""

            ;;

            8)

              echo ""
              echo "  Inicializando la base de datos en MariaDB..."
              echo ""

              # Comprobar antes de nada que la configuración apunta a MariaDB. Si no se hace
              # esta comprobación y la configuración no está bien, flask db upgrade crea las
              # tablas en la SQLite de CTFd/ctfd.db y la instalación queda sobre SQLite sin
              # que nada lo diga.
                if ! fnComprobarQueNoEsSQLite; then
                  echo -e "${cColorRojo}    No se inicializa la base de datos.${cFinColor}"
                  echo ""
                  exit 1
                fi

              cd "$cRutaCTFd"

              echo "    Base de datos a la que se va a migrar (sin la contraseña):"
              sudo grep -E "^DATABASE_(PROTOCOL|USER|HOST|PORT|NAME)=" "$cRutaEnv" | sed 's/^/      /'
              echo ""

              # Es el propio proceso hijo el que carga el .ctfd.env, y no el script padre.
              # Esto es importante: cuando el script se ejecuta usando sudo, sudo limpia el
              # entorno (env_reset), así que las variables que cargara el padre no llegarían
              # hasta aquí y flask se iría a la SQLite. Cargándolas dentro del hijo funciona
              # igual de bien ejecutando el script con sudo que ejecutándolo ya como root.
              # El usuario ctfd puede leer el .ctfd.env porque es del grupo ctfd (modo 640).
              # Se ejecuta como ctfd para que lo que cree (la carpeta .data, por ejemplo) no
              # quede como root.
              # La entrada estándar se manda a /dev/null porque el script se suele ejecutar
              # curleándolo, o sea que su entrada estándar es el propio script llegando por
              # la tubería: si un proceso hijo se pusiera a leer de ahí, se comería las
              # líneas del script que quedan por ejecutar.
                sudo runuser -u ctfd -- bash -c 'set -a; . /opt/CTFd/.ctfd.env; set +a; exec /opt/CTFd/venv/bin/flask db upgrade' < /dev/null

              fnArreglarPermisos

              # Si después de esto apareciera una SQLite, es que algo no fue bien.
                if [ -f "$cRutaCTFd"/CTFd/ctfd.db ]; then
                  echo ""
                  echo -e "${cColorRojo}    ¡Atención! Ha aparecido $cRutaCTFd/CTFd/ctfd.db${cFinColor}"
                  echo -e "${cColorRojo}    Eso significa que la configuración no le llegó a CTFd y ha usado SQLite.${cFinColor}"
                  echo -e "${cColorRojo}    Revisa $cRutaEnv antes de seguir.${cFinColor}"
                  echo ""
                else
                  echo ""
                  echo -e "${cColorVerde}    Base de datos inicializada en MariaDB. No se ha creado ninguna SQLite.${cFinColor}"
                  echo ""
                fi

            ;;

            9)

              echo ""
              echo "  Creando el servicio de systemd y arrancándolo..."
              echo ""

              # Crear primero el script de arranque
                echo '#!/bin/bash'                                                             | sudo tee    "$cRutaCTFd"/Lanzar.sh > /dev/null
                echo ''                                                                        | sudo tee -a "$cRutaCTFd"/Lanzar.sh > /dev/null
                echo 'source /opt/CTFd/venv/bin/activate'                                      | sudo tee -a "$cRutaCTFd"/Lanzar.sh > /dev/null
                echo '  cd /opt/CTFd/'                                                         | sudo tee -a "$cRutaCTFd"/Lanzar.sh > /dev/null
                echo '  # Los workers tienen que ser gevent, no los sync de serie: el'         | sudo tee -a "$cRutaCTFd"/Lanzar.sh > /dev/null
                echo '  # endpoint /events (Server-Sent Events) mantiene una conexion'         | sudo tee -a "$cRutaCTFd"/Lanzar.sh > /dev/null
                echo '  # abierta por cada navegador, y con workers sync cada conexion'        | sudo tee -a "$cRutaCTFd"/Lanzar.sh > /dev/null
                echo '  # bloquea un worker entero, asi que con 4 pestanas abiertas la web'    | sudo tee -a "$cRutaCTFd"/Lanzar.sh > /dev/null
                echo '  # se queda colgada y gunicorn empieza a matar workers en bucle con'    | sudo tee -a "$cRutaCTFd"/Lanzar.sh > /dev/null
                echo '  # WORKER TIMEOUT. Con gevent son corrutinas y no bloquean.'            | sudo tee -a "$cRutaCTFd"/Lanzar.sh > /dev/null
                echo '  # --worker-tmp-dir en /dev/shm es lo que recomienda CTFd, para que'    | sudo tee -a "$cRutaCTFd"/Lanzar.sh > /dev/null
                echo '  # el latido de los workers no dependa de la velocidad del disco.'      | sudo tee -a "$cRutaCTFd"/Lanzar.sh > /dev/null
                echo "  gunicorn -w 4 -k gevent --worker-connections 1000 --timeout 120 \\"    | sudo tee -a "$cRutaCTFd"/Lanzar.sh > /dev/null
                echo "    --worker-tmp-dir /dev/shm -b 127.0.0.1:4000 'CTFd:create_app()'"     | sudo tee -a "$cRutaCTFd"/Lanzar.sh > /dev/null
                echo 'deactivate'                                                              | sudo tee -a "$cRutaCTFd"/Lanzar.sh > /dev/null
                sudo chmod +x "$cRutaCTFd"/Lanzar.sh

              # Crear el servicio.
              # EnvironmentFile es imprescindible: sin esa línea, CTFd no lee el .ctfd.env y
              # se ignoraría toda la configuración (base de datos, Redis, SECRET_KEY...).
              # After/Wants con mariadb y redis, porque CTFd necesita las dos cosas para
              # arrancar en condiciones. Se usa Wants y no Requires para que un fallo de
              # Redis no impida que CTFd arranque.
                echo "[Unit]"                                                                  | sudo tee    /etc/systemd/system/ctfd.service > /dev/null
                echo "Description=CTFd Service"                                                | sudo tee -a /etc/systemd/system/ctfd.service > /dev/null
                echo "# CTFd guarda los datos en MariaDB y usa Redis para la cache"            | sudo tee -a /etc/systemd/system/ctfd.service > /dev/null
                echo "# compartida entre workers y para el gestor de eventos (SSE), asi"       | sudo tee -a /etc/systemd/system/ctfd.service > /dev/null
                echo "# que debe arrancar despues de los dos."                                 | sudo tee -a /etc/systemd/system/ctfd.service > /dev/null
                echo "After=network.target mariadb.service redis-server.service"               | sudo tee -a /etc/systemd/system/ctfd.service > /dev/null
                echo "Wants=mariadb.service redis-server.service"                              | sudo tee -a /etc/systemd/system/ctfd.service > /dev/null
                echo ""                                                                        | sudo tee -a /etc/systemd/system/ctfd.service > /dev/null
                echo "[Service]"                                                               | sudo tee -a /etc/systemd/system/ctfd.service > /dev/null
                echo "User=ctfd"                                                               | sudo tee -a /etc/systemd/system/ctfd.service > /dev/null
                echo "Group=ctfd"                                                              | sudo tee -a /etc/systemd/system/ctfd.service > /dev/null
                echo "WorkingDirectory=/opt/CTFd/"                                             | sudo tee -a /etc/systemd/system/ctfd.service > /dev/null
                echo "# Sin esta linea CTFd no ve la configuracion y se va a SQLite."          | sudo tee -a /etc/systemd/system/ctfd.service > /dev/null
                echo "EnvironmentFile=/opt/CTFd/.ctfd.env"                                     | sudo tee -a /etc/systemd/system/ctfd.service > /dev/null
                echo "ExecStart=/opt/CTFd/Lanzar.sh"                                           | sudo tee -a /etc/systemd/system/ctfd.service > /dev/null
                echo "Restart=always"                                                          | sudo tee -a /etc/systemd/system/ctfd.service > /dev/null
                echo "RestartSec=5"                                                            | sudo tee -a /etc/systemd/system/ctfd.service > /dev/null
                echo ""                                                                        | sudo tee -a /etc/systemd/system/ctfd.service > /dev/null
                echo "[Install]"                                                               | sudo tee -a /etc/systemd/system/ctfd.service > /dev/null
                echo "WantedBy=multi-user.target"                                               | sudo tee -a /etc/systemd/system/ctfd.service > /dev/null

              fnArreglarPermisos

              sudo systemctl daemon-reload
              sudo systemctl enable ctfd --now

              echo ""
              echo "    Esperando a que arranquen los workers..."
              sleep 10
              sudo systemctl status ctfd --no-pager -l | head -20
              echo ""

            ;;

            10)

              echo ""
              echo "  Instalando el proxy inverso con nginx..."
              echo ""

              sudo apt-get -y update
              sudo apt-get -y install nginx openssl

              # Obtener nombre DNS e IP del servidor
              vNombreDNS=$(hostname -f 2>/dev/null)
              if [ -z "$vNombreDNS" ]; then
                vNombreDNS=$(hostname)
              fi

              vIPServidor=$(hostname -I 2>/dev/null | sed 's/ .*//')

              # Crear SAN para el certificado
              if [ -n "$vIPServidor" ]; then
                vSAN="DNS:$vNombreDNS,IP:$vIPServidor"
              else
                vSAN="DNS:$vNombreDNS"
              fi

              # Crear certificado autofirmado
              if [ ! -f /etc/ssl/certs/ctfd.crt ] || [ ! -f /etc/ssl/private/ctfd.key ]; then

                echo ""
                echo "  Generando certificado HTTPS autofirmado..."
                echo ""

                sudo openssl req \
                  -x509 \
                  -nodes \
                  -newkey rsa:4096 \
                  -sha256 \
                  -days 3650 \
                  -keyout /etc/ssl/private/ctfd.key \
                  -out /etc/ssl/certs/ctfd.crt \
                  -subj "/CN=$vNombreDNS" \
                  -addext "subjectAltName=$vSAN"

                sudo chmod 600 /etc/ssl/private/ctfd.key
                sudo chmod 644 /etc/ssl/certs/ctfd.crt

              fi

              # Deshabilitar el sitio por defecto
                sudo rm -f /etc/nginx/sites-enabled/default
              # Crear la configuración de Nginx
                # HTTP -> HTTPS
                  echo "server {"                                                      | sudo tee    /etc/nginx/sites-available/ctfd > /dev/null
                  echo " listen 80 default_server;"                                    | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo " listen [::]:80 default_server;"                               | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo ""                                                              | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo " server_name _;"                                               | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo ""                                                              | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo ' return 301 https://$host$request_uri;'                        | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo "}"                                                             | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                # HTTPS
                  echo ""                                                              | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo "server {"                                                      | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo " listen 443 ssl default_server;"                               | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo " listen [::]:443 ssl default_server;"                          | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo " http2 on;"                                                    | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo ""                                                              | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo " server_name _;"                                               | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo ""                                                              | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo " ssl_certificate /etc/ssl/certs/ctfd.crt;"                     | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo " ssl_certificate_key /etc/ssl/private/ctfd.key;"               | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo " ssl_protocols TLSv1.2 TLSv1.3;"                               | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo ""                                                              | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo " # Los archivos que se suben a los retos pueden ser grandes."   | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo " client_max_body_size 256M;"                                    | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo ""                                                              | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo " # /events es Server-Sent Events: una conexion HTTP que se"     | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo " # queda abierta y por la que CTFd manda un ping cada 5 s."     | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo " # Necesita HTTP/1.1 y el buffer desactivado: con la"           | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo " # configuracion de serie, nginx bufferea la respuesta y las"   | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo " # notificaciones no llegan nunca al navegador."                | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo " location /events {"                                            | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo "  proxy_pass http://127.0.0.1:4000;"                            | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo "  proxy_http_version 1.1;"                                      | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo '  proxy_set_header Connection "";'                              | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo '  proxy_set_header Host $host;'                                 | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo '  proxy_set_header X-Real-IP $remote_addr;'                     | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo '  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;' | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo '  proxy_set_header X-Forwarded-Proto $scheme;'                  | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo "  proxy_buffering off;"                                         | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo "  proxy_cache off;"                                             | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo "  proxy_read_timeout 1h;"                                       | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo "  chunked_transfer_encoding off;"                               | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo " }"                                                             | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo ""                                                              | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo " location / {"                                                 | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo "  proxy_pass http://127.0.0.1:4000;"                           | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo "  proxy_http_version 1.1;"                                     | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo '  proxy_set_header Connection "";'                             | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo '  proxy_set_header Host $host;'                                | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo '  proxy_set_header X-Real-IP $remote_addr;'                    | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo '  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;'| sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo '  proxy_set_header X-Forwarded-Host $host;'                    | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo '  proxy_set_header X-Forwarded-Proto $scheme;'                 | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo '  proxy_set_header X-Forwarded-Port $server_port;'             | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo " }"                                                            | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null
                  echo "}"                                                             | sudo tee -a /etc/nginx/sites-available/ctfd > /dev/null

              # Habilitar la configuración
              sudo ln -sfn /etc/nginx/sites-available/ctfd /etc/nginx/sites-enabled/ctfd

              # Comprobar la configuración
              sudo nginx -t

              # Reiniciar Nginx
              sudo systemctl restart nginx

              echo ""
              echo "  CTFd disponible mediante:"
              echo ""
              echo "    http://$vIPServidor/"
              echo "    https://$vIPServidor/"
              echo ""

            ;;

            11)

            echo ""
            echo " Instalando el proxy inverso con haproxy..."
            echo ""
            sudo apt-get -y update
            sudo apt-get -y install haproxy openssl
            # Obtener nombre DNS e IP del servidor
              vNombreDNS=$(hostname -f 2>/dev/null)
              if [ -z "$vNombreDNS" ]; then
                vNombreDNS=$(hostname)
              fi
              vIPServidor=$(hostname -I 2>/dev/null | sed 's/ .*//')
            # Crear SAN para el certificado
              if [ -n "$vIPServidor" ]; then
                vSAN="DNS:$vNombreDNS,IP:$vIPServidor"
              else
                vSAN="DNS:$vNombreDNS"
              fi

            # Crear certificado autofirmado
              if [ ! -f /etc/ssl/certs/ctfd.crt ] || [ ! -f /etc/ssl/private/ctfd.key ]; then
                echo ""
                echo " Generando certificado HTTPS autofirmado..."
                echo ""
                sudo openssl req \
                  -x509 \
                  -nodes \
                  -newkey rsa:4096 \
                  -sha256 \
                  -days 3650 \
                  -keyout /etc/ssl/private/ctfd.key \
                  -out /etc/ssl/certs/ctfd.crt \
                  -subj "/CN=$vNombreDNS" \
                  -addext "subjectAltName=$vSAN"
                sudo chmod 600 /etc/ssl/private/ctfd.key
                sudo chmod 644 /etc/ssl/certs/ctfd.crt
              fi

            # Crear el PEM que necesita HAProxy
              sudo mkdir -p /etc/haproxy/certs/
              sudo cat /etc/ssl/certs/ctfd.crt /etc/ssl/private/ctfd.key | sudo tee /etc/haproxy/certs/ctfd.pem > /dev/null
              sudo chmod 600 /etc/haproxy/certs/ctfd.pem

            # Crear la configuración de HAProxy
              echo "global"          | sudo tee    /etc/haproxy/haproxy.cfg > /dev/null
              echo "  user haproxy"  | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo "  group haproxy" | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo ""                | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null

              echo "defaults"              | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo "  mode http"           | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo "  timeout connect 60s" | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo "  timeout client 60s"  | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo "  timeout server 60s"  | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo ""                      | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null

            # HTTP y HTTPS
            # Si delante de esta maquina hubiera otro HAProxy enviando el protocolo PROXY
            # (send-proxy), habria que anadir accept-proxy a los bind del 443, o el backend
            # se quedaria caido.
              echo "frontend ctfd"                                                                                      | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo "  bind 0.0.0.0:80"                                                                                  | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo "  bind [::]:80 v6only"                                                                              | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo "  bind 0.0.0.0:443 ssl crt /etc/haproxy/certs/ctfd.pem ssl-min-ver TLSv1.2 ssl-max-ver TLSv1.3"     | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo "  bind [::]:443 v6only ssl crt /etc/haproxy/certs/ctfd.pem ssl-min-ver TLSv1.2 ssl-max-ver TLSv1.3" | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo ""                                                                                                   | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null

            # HTTP -> HTTPS
              echo "  http-request redirect scheme https code 301 unless { ssl_fc }" | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo ""                                                                | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null

            # Cabeceras del proxy inverso
              echo "  option forwardfor"                                         | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo '  http-request set-header Host %[req.hdr(host)]'             | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo '  http-request set-header X-Real-IP %[src]'                  | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo '  http-request set-header X-Forwarded-Host %[req.hdr(host)]' | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo "  http-request set-header X-Forwarded-Proto https"           | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo "  http-request set-header X-Forwarded-Port 443"              | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo ""                                                            | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null

            # Server-Sent Events
              echo "  # El endpoint /events (Server-Sent Events) es una conexion HTTP de"    | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo "  # larga duracion por la que CTFd manda un ping cada 5 s. Va a un"     | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo "  # backend aparte con timeouts holgados, para que el timeout server"   | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo "  # de 60s general no la corte si la aplicacion tarda en responder."    | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo "  acl acl_sse path /events"                                             | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo "  use_backend ctfd_sse if acl_sse"                                      | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo ""                                                                       | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null

              echo "  default_backend ctfd_backend" | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo ""                               | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null

            # Backend CTFd
              echo "backend ctfd_backend"           | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo "  server ctfd 127.0.0.1:4000"   | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo ""                               | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null

            # Backend para las conexiones SSE
              echo "backend ctfd_sse"                                                     | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo "  # Conexiones SSE de larga duracion: sin timeout corto y sin"        | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo "  # bufferear, para que las notificaciones lleguen al navegador en"   | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo "  # cuanto se generan."                                               | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo "  timeout server 1h"                                                  | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo "  timeout tunnel 1h"                                                  | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo "  option http-no-delay"                                               | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
              echo "  server ctfd 127.0.0.1:4000"                                         | sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null

            # Comprobar la configuración
              sudo haproxy -c -f /etc/haproxy/haproxy.cfg

            # Reiniciar HAProxy
              sudo systemctl restart haproxy

            echo ""
            echo " CTFd disponible mediante:"
            echo ""
            echo " http://$vIPServidor/"
            echo " https://$vIPServidor/"
            echo ""

            ;;

            12)

              echo ""
              echo "  Comprobando la instalación..."
              echo ""

              vFallos=0

              # Servicios
                echo "    Servicios:"
                for vServicio in mariadb redis-server ctfd; do
                  vEstado=$(systemctl is-active "$vServicio" 2>/dev/null)
                  if [ "$vEstado" == "active" ]; then
                    echo -e "      $vServicio: ${cColorVerde}$vEstado${cFinColor}"
                  else
                    echo -e "      $vServicio: ${cColorRojo}$vEstado${cFinColor}"
                    vFallos=$((vFallos+1))
                  fi
                done
                echo ""

              # Base de datos que está usando de verdad.
              # Si aquí apareciera SQLiteImpl, es que la configuración no le está llegando.
                echo "    Base de datos en uso:"
                vImpl=$(sudo journalctl -u ctfd -b --no-pager 2>/dev/null | grep -oE "SQLiteImpl|MySQLImpl" | sort -u | tr '\n' ' ')
                if echo "$vImpl" | grep -q "MySQLImpl" && ! echo "$vImpl" | grep -q "SQLiteImpl"; then
                  echo -e "      ${cColorVerde}MySQLImpl (MariaDB). Correcto.${cFinColor}"
                elif echo "$vImpl" | grep -q "SQLiteImpl"; then
                  echo -e "      ${cColorRojo}¡SQLiteImpl! La configuración no le está llegando a CTFd.${cFinColor}"
                  echo -e "      ${cColorRojo}Revisa que el servicio tenga EnvironmentFile=/opt/CTFd/.ctfd.env${cFinColor}"
                  vFallos=$((vFallos+1))
                else
                  echo -e "      ${cColorRojo}No se ha podido determinar. Mira: journalctl -u ctfd${cFinColor}"
                  vFallos=$((vFallos+1))
                fi
                echo ""

              # No debe existir ninguna SQLite
                echo "    Archivo de SQLite:"
                if [ -f "$cRutaCTFd"/CTFd/ctfd.db ]; then
                  echo -e "      ${cColorRojo}existe $cRutaCTFd/CTFd/ctfd.db. No debería. Algo se instaló sobre SQLite.${cFinColor}"
                  vFallos=$((vFallos+1))
                else
                  echo -e "      ${cColorVerde}no existe. Correcto.${cFinColor}"
                fi
                echo ""

              # Tipo de worker de gunicorn
                echo "    Tipo de worker de gunicorn:"
                if sudo journalctl -u ctfd -b --no-pager 2>/dev/null | grep -q "Using worker: gevent"; then
                  echo -e "      ${cColorVerde}gevent. Correcto.${cFinColor}"
                else
                  echo -e "      ${cColorRojo}no es gevent. Las conexiones a /events bloquearán los workers.${cFinColor}"
                  vFallos=$((vFallos+1))
                fi
                echo ""

              # WORKER TIMEOUT: con gevent no debería haber ninguno
                echo "    WORKER TIMEOUT en este arranque:"
                vTimeouts=$(sudo journalctl -u ctfd -b --no-pager 2>/dev/null | grep -c "WORKER TIMEOUT")
                if [ "$vTimeouts" == "0" ]; then
                  echo -e "      ${cColorVerde}0. Correcto.${cFinColor}"
                else
                  echo -e "      ${cColorRojo}$vTimeouts. Revisa que los workers sean gevent.${cFinColor}"
                  vFallos=$((vFallos+1))
                fi
                echo ""

              # Workers suscritos al canal de eventos de Redis.
              # Deberían ser tantos como workers tenga gunicorn.
                echo "    Workers suscritos al canal de eventos en Redis:"
                vSubs=$(redis-cli pubsub numsub ctf 2>/dev/null | tail -1)
                if [ -n "$vSubs" ] && [ "$vSubs" != "0" ]; then
                  echo -e "      ${cColorVerde}$vSubs. Correcto.${cFinColor}"
                else
                  echo -e "      ${cColorRojo}ninguno. CTFd no está usando Redis para los eventos.${cFinColor}"
                  vFallos=$((vFallos+1))
                fi
                echo ""

              # Respuesta de la aplicación
                echo "    Respuesta de la aplicación en el 4000:"
                vRespuesta=$(curl -s -o /dev/null -w "código %{http_code} en %{time_total}s" --max-time 30 http://127.0.0.1:4000/ 2>/dev/null)
                echo "      $vRespuesta"
                echo ""

              if [ "$vFallos" == "0" ]; then
                echo -e "${cColorVerde}    Todo correcto. CTFd está sobre MariaDB, con Redis y con workers gevent.${cFinColor}"
              else
                echo -e "${cColorRojo}    Hay $vFallos comprobaciones con problemas. Míralas antes de dar la instalación por buena.${cFinColor}"
              fi
              echo ""

            ;;

            13)

              echo ""
              echo -e "${cColorVerde}  Instalación finalizada.${cFinColor}"
              echo ""
              echo "    Servicio:"
              echo ""
              echo "      systemctl status ctfd --no-pager"
              echo "      journalctl -u ctfd -f"
              echo ""
              echo "    Archivos:"
              echo ""
              echo "      Configuración de CTFd:  $cRutaEnv"
              echo "      Contraseñas generadas:  $cRutaCredenciales"
              echo "      Script de arranque:     $cRutaCTFd/Lanzar.sh"
              echo "      Servicio de systemd:    /etc/systemd/system/ctfd.service"
              echo ""
              echo "    La contraseña de root de MariaDB no se ha tocado: entra con"
              echo ""
              echo "      sudo mariadb"
              echo ""
              echo "    Dos comprobaciones que conviene repetir de vez en cuando:"
              echo ""
              echo "      journalctl -u ctfd | grep -oE 'SQLiteImpl|MySQLImpl'   # tiene que decir MySQLImpl"
              echo "      redis-cli pubsub numsub ctf                            # tantos como workers"
              echo ""
              echo "    Lo primero que hay que hacer ahora es entrar por la web y completar el"
              echo "    asistente de configuración inicial de CTFd, que es donde se crea la"
              echo "    cuenta de administración."
              echo ""

            ;;

        esac

    done

  elif [ "$cVerSO" == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de CTFd para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 12 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ "$cVerSO" == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de CTFd para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ "$cVerSO" == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de CTFd para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ "$cVerSO" == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de CTFd para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ "$cVerSO" == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de CTFd para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ "$cVerSO" == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de CTFd para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
