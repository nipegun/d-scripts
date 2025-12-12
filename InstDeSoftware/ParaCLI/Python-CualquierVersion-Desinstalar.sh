#!/bin/bash

pyenv versions | awk '{print $1}' | xargs -n1 pyenv uninstall -f 
rm -rf ~/.pyenv

# Limpiar .bashrc
  vBashrc="$HOME/.bashrc"
  fEliminarLineasPyenv() {
    sed -i \
      -e '/export PYENV_ROOT="\$HOME\/\.pyenv"/d' \
      -e '/export PATH="\$PYENV_ROOT\/bin:\$PATH"/d' \
      -e '/eval "\$(pyenv init -)"/d' \
      "$vBashrc"
    }
  fEliminarLineasPyenv
  echo "Líneas de pyenv eliminadas de $vBashrc"
  echo ""
