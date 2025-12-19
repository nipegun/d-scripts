#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar cualquier versión de Python en Debian 13 utilizando pyenv
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/Python-CualquierVersion-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/Python-CualquierVersion-Instalar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/Python-CualquierVersion-Instalar.sh | nano -
# ----------

vPyenvDir="$HOME/.pyenv"

fInstalarDependencias() {
  sudo apt-get update
  sudo apt-get install -y make
  sudo apt-get install -y build-essential
  sudo apt-get install -y libssl-dev
  sudo apt-get install -y zlib1g-dev
  sudo apt-get install -y libbz2-dev
  sudo apt-get install -y libreadline-dev
  sudo apt-get install -y libsqlite3-dev
  sudo apt-get install -y wget
  sudo apt-get install -y curl
  sudo apt-get install -y llvm
  sudo apt-get install -y libncursesw5-dev
  sudo apt-get install -y xz-utils
  sudo apt-get install -y tk-dev
  sudo apt-get install -y libxml2-dev
  sudo apt-get install -y libxmlsec1-dev
  sudo apt-get install -y libffi-dev
  sudo apt-get install -y liblzma-dev
}


fInstalarPyenv() {
  if [ ! -d "$vPyenvDir" ]; then
    git clone https://github.com/pyenv/pyenv.git "$vPyenvDir"
  fi

  if ! grep -q 'pyenv init' "$HOME/.bashrc"; then
    echo '' >> "$HOME/.bashrc"
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> "$HOME/.bashrc"
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> "$HOME/.bashrc"
    echo 'eval "$(pyenv init -)"' >> "$HOME/.bashrc"
  fi
}


fCargarPyenv() {
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
}


fMostrarMenu() {
  clear
  echo "=================================================="
  echo "        Instalación de versiones de Python        "
  echo "=================================================="
  echo
  echo "Obteniendo lista de versiones..."
  echo

  aVersiones=($(pyenv install --list | sed 's/^[[:space:]]*//' | grep -E '^[0-9]+\.[0-9]+' ))

  vCont=1
  for vVersion in "${aVersiones[@]}"; do
    echo " $vCont) $vVersion"
    ((vCont++))
  done

  echo
  echo "Seleccione números separados por espacios (ej: 1 3 5):"
  if [ -n "$1" ]; then
    vSeleccion="$1"
  else
    read -r vSeleccion < /dev/tty
  fi
}


fInstalarVersiones() {
  for vNum in $vSeleccion; do
    vVersion="${aVersiones[$((vNum-1))]}"

    if [ -z "$vVersion" ]; then
      echo "Índice inválido: $vNum"
      continue
    fi

    echo
    echo "Instalando Python $vVersion..."
    pyenv install "$vVersion"
  done
}


# --------------------------
# EJECUCIÓN PRINCIPAL
# --------------------------

fInstalarDependencias
fInstalarPyenv
fCargarPyenv
fMostrarMenu
fInstalarVersiones

echo
echo "Instalación finalizada."
echo ""
echo "  Para decirle a pyenv que versión de Python será la versión por defecto del sistema para tu usuario:"
echo "    pyenv global 3.9.0"
echo ""
echo "  Para fijar una versión solo para un directorio concreto."
echo "    cd $HOME/pruebas && pyenv local 3.9.0"
echo ""
