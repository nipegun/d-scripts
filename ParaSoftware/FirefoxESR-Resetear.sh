#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para resetear Firefox ESR en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/FirefoxESR-Resetear.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/FirefoxESR-Resetear.sh | sed 's-sudo--g' | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/FirefoxESR-Resetear.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/FirefoxESR-Resetear.sh | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/FirefoxESR-Resetear.sh | nano -
# ----------

set -Eeuo pipefail

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

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

# Ejecutar comandos dependiendo de la versión de Debian detectada

  if [ $cVerSO == "13" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de reseteo de Firefox ESR en Debian 13 (x)...${cFinColor}"
    echo ""

    cUid="$(id -u)"
    cUsuario="$(id -un)"
    cHome="$HOME"

    vXdgCache="${XDG_CACHE_HOME:-$cHome/.cache}"
    vXdgConfig="${XDG_CONFIG_HOME:-$cHome/.config}"
    vXdgData="${XDG_DATA_HOME:-$cHome/.local/share}"
    vXdgState="${XDG_STATE_HOME:-$cHome/.local/state}"
    vXdgRuntime="${XDG_RUNTIME_DIR:-/run/user/$cUid}"

    if [ "$cUid" -eq 0 ]; then
      echo "ERROR: Ejecuta este script como el usuario normal, sin sudo."
      exit 1
    fi

    fObtenerPidsFirefox() {
      local vProc
      local vPid
      local vProcUid
      local vExe
      local vBase
      local vComm
      local vCmd

      for vProc in /proc/[0-9]*; do
        vPid="${vProc##*/}"

        if [ "$vPid" -eq "$$" ]; then
          continue
        fi

        vProcUid="$(stat -c '%u' "$vProc" 2>/dev/null)" || continue

        if [ "$vProcUid" != "$cUid" ]; then
          continue
        fi

        vExe="$(readlink -f "$vProc/exe" 2>/dev/null || true)"
        vBase="${vExe##*/}"
        vComm="$(cat "$vProc/comm" 2>/dev/null || true)"
        vCmd="$(tr '\0' ' ' < "$vProc/cmdline" 2>/dev/null || true)"

        case "$vExe" in
          */firefox-esr/*|*/firefox/*|*/firefox-esr|*/firefox|*/firefox-bin)
            echo "$vPid"
            continue
            ;;
        esac

        case "$vBase" in
          firefox|firefox-esr|firefox-bin)
            echo "$vPid"
            continue
            ;;
        esac

        case "$vComm" in
          firefox|firefox-esr|firefox-bin)
            echo "$vPid"
            continue
            ;;
        esac

        case "$vCmd" in
          *org.mozilla.firefox*)
            echo "$vPid"
            ;;
        esac
      done
    }

    fTerminarFirefox() {
      local vPids
      local vIntento

      vPids="$(fObtenerPidsFirefox | sort -nu)"

      if [ -n "$vPids" ]; then
        echo "Terminando procesos de Firefox con SIGTERM:"
        echo "$vPids"
        kill -TERM $vPids 2>/dev/null || true
      fi

      for ((vIntento = 0; vIntento < 30; vIntento++)); do
        sleep 0.1

        vPids="$(fObtenerPidsFirefox | sort -nu)"

        if [ -z "$vPids" ]; then
          break
        fi
      done

      vPids="$(fObtenerPidsFirefox | sort -nu)"

      if [ -n "$vPids" ]; then
        echo "Firefox no terminó limpiamente. Forzando SIGKILL:"
        echo "$vPids"
        kill -KILL $vPids 2>/dev/null || true
        sleep 0.5
      fi

      vPids="$(fObtenerPidsFirefox | sort -nu)"

      if [ -n "$vPids" ]; then
        echo "ERROR: Todavía quedan procesos relacionados con Firefox:"
        echo "$vPids"
        return 1
      fi

      echo "Comprobación correcta: no queda ningún proceso de Firefox del usuario $cUsuario."
    }

    fBorrarRuta() {
      local pRuta="$1"

      if [ -z "$pRuta" ] || [ "$pRuta" = "/" ]; then
        echo "ERROR: Ruta de borrado no válida: '$pRuta'"
        return 1
      fi

      if [ -e "$pRuta" ] || [ -L "$pRuta" ]; then
        echo "Borrando: $pRuta"
        rm -rf -- "$pRuta"
      fi
    }

    fLimpiarTemporales() {
      if [ -d /tmp ]; then
        find /tmp -xdev -mindepth 1 -maxdepth 1 -uid "$cUid" \
          \( -name "mozilla_${cUsuario}[0-9]*" \
          -o -name 'mozilla-temp-*' \
          -o -name '.org.mozilla.firefox.*' \
          -o -name 'org.mozilla.firefox.*' \) \
          -exec rm -rf -- {} + 2>/dev/null || true
      fi

      if [ -d "$vXdgRuntime" ]; then
        find "$vXdgRuntime" -xdev -mindepth 1 -maxdepth 1 -uid "$cUid" \
          \( -iname '*firefox*' -o -iname '*mozilla*' \) \
          -exec rm -rf -- {} + 2>/dev/null || true
      fi
    }

    fComprobarRutas() {
      local pRuta
      local vRestos=0

      for pRuta in "$@"; do
        if [ -e "$pRuta" ] || [ -L "$pRuta" ]; then
          echo "ERROR: Sigue existiendo: $pRuta"
          vRestos=1
        fi
      done

      return "$vRestos"
    }

    aRutasFirefox=(
      "$cHome/.mozilla/firefox"
      "$cHome/.mozilla/extensions"

      "$vXdgCache/mozilla/firefox"
      "$vXdgConfig/mozilla/firefox"
      "$vXdgData/mozilla/firefox"
      "$vXdgState/mozilla/firefox"

      "$vXdgCache/firefox"
      "$vXdgConfig/firefox"
      "$vXdgData/firefox"
      "$vXdgState/firefox"

      "$cHome/.var/app/org.mozilla.firefox"
      "$cHome/snap/firefox"
    )

    echo "Usuario: $cUsuario"
    echo "HOME: $cHome"
    echo

    fTerminarFirefox

    echo

    for vRuta in "${aRutasFirefox[@]}"; do
      fBorrarRuta "$vRuta"
    done

    fLimpiarTemporales

    rmdir -- "$cHome/.mozilla" 2>/dev/null || true
    rmdir -- "$vXdgCache/mozilla" 2>/dev/null || true
    rmdir -- "$vXdgConfig/mozilla" 2>/dev/null || true
    rmdir -- "$vXdgData/mozilla" 2>/dev/null || true
    rmdir -- "$vXdgState/mozilla" 2>/dev/null || true

    echo

    if ! fComprobarRutas "${aRutasFirefox[@]}"; then
      echo "ERROR: La limpieza no ha sido completa."
      exit 1
    fi

    echo "Limpieza terminada."
    echo "Firefox ESR arrancará con un perfil nuevo en la próxima ejecución."

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de reseteo de Firefox ESR en Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 12 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de reseteo de Firefox ESR en Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de reseteo de Firefox ESR en Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de reseteo de Firefox ESR en Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de reseteo de Firefox ESR en Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de reseteo de Firefox ESR en Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
