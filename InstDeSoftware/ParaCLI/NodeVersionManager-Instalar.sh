#!/bin/bash


            # Instalar paquetes necesarios para la correcta ejecución del script
              sudo apt-get -y update
              sudo apt-get -y install curl 2> /dev/null
              sudo apt-get -y install jq   2> /dev/null

              echo ""
              echo "      Determinando la última versión de nvm..."
              echo ""
              vUltVersNVM=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | jq -r '.tag_name')
              echo "        La última versión de nvm es $vUltVersNVM"
              echo ""
              echo ""
              echo "      Instalando..."
              echo ""
              cd /tmp
              curl -sL https://raw.githubusercontent.com/nvm-sh/nvm/"$vUltVersNVM"/install.sh | bash

