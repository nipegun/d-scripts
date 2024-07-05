#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar diferentes modelos LLM de Ollama en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/LMStudio-ModelosLLM-Instalar.sh | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/LMStudio-ModelosLLM-Instalar.sh | bash
# ----------

# Indicar la cuenta de usuario no root
  vUsuarioNoRoot="usuariox"

# Indicar la carpeta donde se guardarán los modelos
  vCarpetaDeModelosLLM="/home/$vUsuarioNoRoot/.cache/lm-studio/models"
  #vCarpetaDeModelosLLM="/home/$vUsuarioNoRoot/IA/LMStudio/ModelosLLM"
  

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
    apt-get -y update
    apt-get -y install dialog
    echo ""
  fi

# Crear el menú
  menu=(dialog --checklist "Marca los modelos que quieras instalar:" 22 96 16)
    opciones=(
      1 "LM Studio Community Llama3 8b instruct, cuantificación Q8" off
      2 "LM Studio Community Gemma2 9b instruct, cuantificación Q8" off
      3 "LM Studio Community Gemma2 27b instruct, cuantificación Q8" off
      4 "LM Studio Community Mistral v0.3 7b instruct, cuantificación Q8" off
      5 "LM Studio Community Mistral v0.3 7b instruct, cuantificación FP32" off
      6 "LM Studio Community Phi3 mini instruct 4k, cuantificación Q8" off
      7 "LM Studio Community Phi3 mini instruct 4k, cuantificación FP16" off
      8 "LM Studio Community Phi3 mini instruct 4k, cuantificación FP32" off
      9 "LM Studio Community DeepSeek Coder v2 lite instruct, cuantificación Q8" off
     10 "x" off
     11 "x" off
     12 "x" off
     13 "x" off
     14 "x" off
     15 "x" off
     16 "x" off
     17 "x" off
     18 "x" off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "  Instalando LM Studio Community Llama3 8b instruct, cuantificación Q8 (Meta-Llama-3-8B-Instruct-Q8_0.gguf)..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=9
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                mkdir -p $vCarpetaDeModelosLLM 2> /dev/null
                curl -L --create-dirs -O --output-dir "$vCarpetaDeModelosLLM/LM Studio Community/Meta-Llama-3-8B-Instruct-gguf" https://huggingface.co/lmstudio-community/Meta-Llama-3-8B-Instruct-GGUF/resolve/main/Meta-Llama-3-8B-Instruct-Q8_0.gguf
                chown $vUsuarioNoRoot:$vUsuarioNoRoot "$vCarpetaDeModelosLLM" -R
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3:8b.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          2)

            echo ""
            echo "  Instalando LM Studio Community Gemma2 9b instruct, cuantificación Q8 (gemma-2-9b-it-Q8_0.gguf)..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=10
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                mkdir -p $vCarpetaDeModelosLLM 2> /dev/null
                curl -L --create-dirs -O --output-dir "$vCarpetaDeModelosLLM/LM Studio Community/gemma-2-9b-it-Q8_0-gguf" https://huggingface.co/lmstudio-community/gemma-2-9b-it-GGUF/resolve/main/gemma-2-9b-it-Q8_0.gguf
                chown $vUsuarioNoRoot:$vUsuarioNoRoot "$vCarpetaDeModelosLLM" -R
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3:70b.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          3)

            echo ""
            echo "  Instalando LM Studio Community Gemma2 27b instruct, cuantificación Q8 (gemma-2-27b-it-Q8_0.gguf)..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=28
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                mkdir -p $vCarpetaDeModelosLLM 2> /dev/null
                curl -L --create-dirs -O --output-dir "$vCarpetaDeModelosLLM/LM Studio Community/gemma-2-27b-it-Q8_0-gguf" https://huggingface.co/lmstudio-community/gemma-2-27b-it-GGUF/resolve/main/gemma-2-27b-it-Q8_0.gguf
                chown $vUsuarioNoRoot:$vUsuarioNoRoot "$vCarpetaDeModelosLLM" -R
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3:8b-instruct-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          4)

            echo ""
            echo "  Instalando LM Studio Community Mistral v0.3 7b instruct, cuantificación Q8 (Mistral-7B-Instruct-v0.3-Q8_0.gguf)..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=8
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                mkdir -p $vCarpetaDeModelosLLM 2> /dev/null
                curl -L --create-dirs -O --output-dir "$vCarpetaDeModelosLLM/LM Studio Community/Mistral-7B-Instruct-v0.3-Q8_0-gguf" https://huggingface.co/lmstudio-community/Mistral-7B-Instruct-v0.3-GGUF/resolve/main/Mistral-7B-Instruct-v0.3-Q8_0.gguf
                chown $vUsuarioNoRoot:$vUsuarioNoRoot "$vCarpetaDeModelosLLM" -R
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3:70b-instruct-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          5)

            echo ""
            echo "  Instalando LM Studio Community Mistral v0.3 7b instruct, cuantificación FP32 (Mistral-7B-Instruct-v0.3-f32.gguf)..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=28
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                mkdir -p $vCarpetaDeModelosLLM 2> /dev/null
                curl -L --create-dirs -O --output-dir "$vCarpetaDeModelosLLM/LM Studio Community/Mistral-7B-Instruct-v0.3-f32-gguf" https://huggingface.co/lmstudio-community/Mistral-7B-Instruct-v0.3-GGUF/resolve/main/Mistral-7B-Instruct-v0.3-f32.gguf
                chown $vUsuarioNoRoot:$vUsuarioNoRoot "$vCarpetaDeModelosLLM" -R
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo mistral:7b.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          6)

            echo ""
            echo "  Instalando LM Studio Community Phi3 mini instruct 4k, cuantificación Q8 (Phi-3-mini-4k-instruct-Q8_0.gguf)..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=4
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                mkdir -p $vCarpetaDeModelosLLM 2> /dev/null
                curl -L --create-dirs -O --output-dir "$vCarpetaDeModelosLLM/LM Studio Community/Phi-3-mini-4k-instruct-Q8_0-gguf" https://huggingface.co/lmstudio-community/Phi-3-mini-4k-instruct-GGUF/resolve/main/Phi-3-mini-4k-instruct-Q8_0.gguf
                chown $vUsuarioNoRoot:$vUsuarioNoRoot "$vCarpetaDeModelosLLM" -R
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo mistral:7b-instruct-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          7)

            echo ""
            echo "  Instalando LM Studio Community Phi3 mini instruct 4k, cuantificación FP16 (Phi-3-mini-4k-instruct-fp16.gguf)..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=8
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                mkdir -p $vCarpetaDeModelosLLM 2> /dev/null
                curl -L --create-dirs -O --output-dir "$vCarpetaDeModelosLLM/LM Studio Community/Phi-3-mini-4k-instruct-fp16-gguf" https://huggingface.co/lmstudio-community/Phi-3-mini-4k-instruct-GGUF/resolve/main/Phi-3-mini-4k-instruct-fp16.gguf
                chown $vUsuarioNoRoot:$vUsuarioNoRoot "$vCarpetaDeModelosLLM" -R
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo phi3:3.8b.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          8)

            echo ""
            echo "  Instalando LM Studio Community Phi3 mini instruct 4k, cuantificación FP32 (Phi-3-mini-4k-instruct-fp32.gguf)..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=15
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                mkdir -p $vCarpetaDeModelosLLM 2> /dev/null
                curl -L --create-dirs -O --output-dir "$vCarpetaDeModelosLLM/LM Studio Community/Phi-3-mini-4k-instruct-fp32-gguf" https://huggingface.co/lmstudio-community/Phi-3-mini-4k-instruct-GGUF/resolve/main/Phi-3-mini-4k-instruct-fp32.gguf
                chown $vUsuarioNoRoot:$vUsuarioNoRoot "$vCarpetaDeModelosLLM" -R
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo phi3:14b.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          9)

            echo ""
            echo "  Instalando LM Studio Community DeepSeek Coder v2 lite instruct, cuantificación Q8 (DeepSeek-Coder-V2-Lite-Instruct-Q8_0.gguf)..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=16
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                mkdir -p $vCarpetaDeModelosLLM 2> /dev/null
                curl -L --create-dirs -O --output-dir "$vCarpetaDeModelosLLM/LM Studio Community/DeepSeek-Coder-V2-Lite-Instruct-Q8_0-gguf" https://huggingface.co/lmstudio-community/DeepSeek-Coder-V2-Lite-Instruct-GGUF/resolve/main/DeepSeek-Coder-V2-Lite-Instruct-Q8_0.gguf
                chown $vUsuarioNoRoot:$vUsuarioNoRoot "$vCarpetaDeModelosLLM" -R
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo phi3:3.8b-mini-128k-instruct-f16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         10)


Phi-3-mini-4k-instruct-q4.gguf
https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf/resolve/main/Phi-3-mini-4k-instruct-q4.gguf

          ;;

         11)

Phi-3-mini-4k-instruct-fp16.gguf
https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf/resolve/main/Phi-3-mini-4k-instruct-fp16.gguf

          ;;

         12)



          ;;

         13)



          ;;

         14)



          ;;


         15)



          ;;

         16)



          ;;

         17)


          ;;

         18)



          ;;

      esac

  done

