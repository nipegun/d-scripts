#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar diferentes modelos LLM de Ollama en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/IA-ModelosLLM-Instalar-Ollama.sh | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/IA-ModelosLLM-Instalar-Ollama.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL x | bash -s Parámetro1 Parámetro2
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Indicar inicio de ejecución del script
  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de modelos LLM para Ollama...${cFinColor}"
  echo ""

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo ""
    echo -e "${cColorRojo}    Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    echo ""
    exit
  fi

# Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    apt-get -y update && apt-get -y install dialog
    echo ""
  fi

# Crear el menú
  menu=(dialog --checklist "Marca los modelos que quieras instalar:" 22 96 16)
    opciones=(

      1 "Modelos de Dolphin-Mistral"
      2 "Modelos de Llama"
      3 "Modelos de Qwen"
      4 "Modelos de Mistral"
      5 "Modelos de Phi"
      6 "Modelos de DeepSeekCoder"
      7 "Modelos de Gemma"

    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "  Instalando modelos de dolphin-mistral..."
            echo ""

            curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/IA-ModelosLLM-Instalar-Ollama-Dolphin-Mistral.sh | bash

          ;;

          2)

            echo ""
            echo "  Instalando modelos de Llama..."
            echo ""

            curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/IA-ModelosLLM-Instalar-Ollama-Llama.sh | bash

          ;;

          3)

            echo ""
            echo "  Instalando modelos de Qwen..."
            echo ""

            curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/IA-ModelosLLM-Instalar-Ollama-Qwen.sh | bash

          ;;

          4)

            echo ""
            echo "  Instalando modelos de Mistral..."
            echo ""

            curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/IA-ModelosLLM-Instalar-Ollama-Mistral.sh | bash

          ;;

          5)

            echo ""
            echo "  Instalando modelos de Phi..."
            echo ""

            curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/IA-ModelosLLM-Instalar-Ollama-Phi.sh | bash

          ;;

          6)

            echo ""
            echo "  Instalando modelos de DeepSeekCoder..."
            echo ""

            curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/IA-ModelosLLM-Instalar-Ollama-DeepSeekCoder.sh | bash

          ;;

          7)

            echo ""
            echo "  Instalando modelos de Gemma..."
            echo ""

            curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/IA-ModelosLLM-Instalar-Ollama-Gemma.sh | bash

          ;;

      esac

  done
