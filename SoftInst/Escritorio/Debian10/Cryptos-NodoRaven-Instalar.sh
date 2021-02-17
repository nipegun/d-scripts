#!/bin/bash

Archivo=$(curl -s https://github.com/RavenProject/Ravencoin/releases/ | grep linux | grep gnu | grep zip | grep href | grep -v disable | cut -d '"' -f 2)

echo $Archivo

mkdir -p /root/CodFuente/NodoRaven/
cd /root/CodFuente/NodoRaven
wget --no-check-certificate https://github.com$Archivo -O /root/CodFuente/NodoRaven/NodoRaven.zip

