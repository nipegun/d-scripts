#!/bin/bash

# Instalar nano
  apt-get -y install nano
  sed -i -e 's|# set linenumbers|set linenumbers|g' /etc/nanorc

# Instalar shellcheck
  apt-get -y install shellcheck
