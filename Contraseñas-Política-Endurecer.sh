#!/bin/bash

# Archivo /etc/login.defs
    cp /etc/login.defs /etc/login.defs.bak
  # Configurar el número máximo de días que se puede usar una contraseña.
    sed -i -e 's|^#PASS_MAX_DAYS|PASS_MAX_DAYS|g'         /etc/login.defs
  # Configurar el número mínimo de días permitido entre cambios de contraseña.
    sed -i -e 's|^#PASS_MIN_DAYS|PASS_MIN_DAYS|g'         /etc/login.defs
  # Configurar el número de días de advertencia antes de que caduque una contraseña.
    sed -i -e 's|^#PASS_WARN_AGE|PASS_WARN_AGE|g'         /etc/login.defs
  # Configurar el número mínimo de caracteres que debe tener la contraseña.
    sed -i -e 's|^#PASS_MIN_LEN|PASS_MIN_LEN|g'           /etc/login.defs
  # Configurar el número máximo de caracteres que debe tener la contraseña.
    sed -i -e 's|^#PASS_MAX_LEN|PASS_MAX_LEN|g'           /etc/login.defs
  # Advertir sobre contraseñas débiles.
    sed -i -e 's|^#PASS_ALWAYS_WARN|PASS_ALWAYS_WARN|g'   /etc/login.defs
  # Configurar el número máximo de intentos de cambiar la contraseña si se rechaza por que es demasiado "fácil".
    sed -i -e 's|^#PASS_CHANGE_TRIES|PASS_CHANGE_TRIES|g' /etc/login.defs
  # Configurar el tipo de cifrado que tendrá la contraseña (SHA256 $5$ o SHA512 $6$).
    sed -i -e 's|^#ENCRYPT_METHOD|ENCRYPT_METHOD|g'       /etc/login.defs
  # Configurar el Número máximo de reintentos de inicio de sesión en el caso de que la contraseña sea incorrecta.
    sed -i -e 's|^#LOGIN_RETRIES|LOGIN_RETRIES|g'         /etc/login.defs
  # Configurar el tiempo máximo en segundos para iniciar sesión.
    sed -i -e 's|^#LOGIN_TIMEOUT|LOGIN_TIMEOUT|g'         /etc/login.defs
# Librería libpam-cracklib
  apt-get -y update
  # apt-get -y install libpam-cracklib

