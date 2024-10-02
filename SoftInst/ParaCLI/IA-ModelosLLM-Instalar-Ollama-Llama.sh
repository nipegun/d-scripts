#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar los diferentes modelos de Llama en Ollama para Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/IA-ModelosLLM-Instalar-Ollama-Llama.sh | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/IA-ModelosLLM-Instalar-Ollama-Llama.sh | bash
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
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de modelos LLM de Llama para Ollama...${cFinColor}"
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

      1 "dolphin-mistral 7b-v2.8-q4_0 ( 4,3 GB en disco) ( 7,4 GB en VRAM)" off
      2 "dolphin-mistral 7b-v2.8-q8_0 ( 7,9 GB en disco) (10,7 GB en VRAM)" off
      3 "dolphin-mistral 7b-v2.8-fp16 (14,2 GB en disco) (15,4 GB en VRAM)?" off

      4 "llama3.2   1b-instruct-q4_0 (0,9 GB en disco) (3,4 GB en VRAM)" off
      5 "llama3.2   1b-instruct-q8_0 (1,5 GB en disco) (3,8 GB en VRAM)" off
      6 "llama3.2   1b-instruct-fp16 (2,7 GB en disco) (7,2 GB en VRAM)" off

      7 "llama3.2   3b-instruct-q4_0 (2,0 GB en disco) ( 4,9 GB en VRAM)" off
      8 "llama3.2   3b-instruct-q8_0 (3,6 GB en disco) ( 9,8 GB en VRAM)" off
      9 "llama3.2   3b-instruct-fp16 (6,6 GB en disco) (14,0 GB en VRAM)" off
      
     10 "llama3.1   8b-instruct-q4_0 ( 4,8 GB en disco) ( 7,5 GB en VRAM)" off
     11 "llama3.1   8b-instruct-q8_0 ( 8,6 GB en disco) (11,0 GB en VRAM)" off
     12 "llama3.1   8b-instruct-fp16 (16,2 GB en disco) (15,8 GB en VRAM)?" off



     13 "llama3.1  70b-instruct-q4_0 ( 40,0 GB en disco) (x,x GB en VRAM)" off
     14 "llama3.1  70b-instruct-q8_0 ( 75,0 GB en disco) (x,x GB en VRAM)" off
     15 "llama3.1  70b-instruct-fp16 (142,0 GB en disco) (x,x GB en VRAM)" off

     16 "llama3.1 405b-instruct-q4_0 (230,0 GB en disco) (x,x GB en VRAM)" off
     17 "llama3.1 405b-instruct-q8_0 (433,0 GB en disco) (x,x GB en VRAM)" off
     18 "llama3.1 405b-instruct-fp16 (815,0 GB en disco) (x,x GB en VRAM)" off



     19 "qwen2.5 0.5-instruct-q4_0 (x,x GB en disco) (x,x GB en VRAM)" off
     20 "qwen2.5 0.5-instruct-q8_0 (x,x GB en disco) (x,x GB en VRAM)" off
     21 "qwen2.5 0.5-instruct-fp16 (x,x GB en disco) (x,x GB en VRAM)" off

     22 "qwen2.5 1.5-instruct-q4_0 (x,x GB en disco) (x,x GB en VRAM)" off
     23 "qwen2.5 1.5-instruct-q8_0 (x,x GB en disco) (x,x GB en VRAM)" off
     24 "qwen2.5 1.5-instruct-fp16 (x,x GB en disco) (x,x GB en VRAM)" off
     
     25 "qwen2.5 3b-instruct-q4_0 (x,x GB en disco) (x,x GB en VRAM)" off
     26 "qwen2.5 3b-instruct-q8_0 (x,x GB en disco) (x,x GB en VRAM)" off
     27 "qwen2.5 3b-instruct-fp16 (x,x GB en disco) (x,x GB en VRAM)" off

     28 "qwen2.5 7b-instruct-q4_0 (x,x GB en disco) (x,x GB en VRAM)" off
     29" qwen2.5 7b-instruct-q8_0 (x,x GB en disco) (x,x GB en VRAM)" off
     30 "qwen2.5 7b-instruct-fp16 (x,x GB en disco) (x,x GB en VRAM)" off

     31 "qwen2.5 14b-instruct-q4_0 (x,x GB en disco) (x,x GB en VRAM)" off
     32 "qwen2.5 14b-instruct-q8_0 (x,x GB en disco) (x,x GB en VRAM)" off
     33 "qwen2.5 14b-instruct-fp16 (x,x GB en disco) (x,x GB en VRAM)" off

     34 "qwen2.5 32b-instruct-q4_0 (x,x GB en disco) (x,x GB en VRAM)" off
     35 "qwen2.5 32b-instruct-q8_0 (x,x GB en disco) (x,x GB en VRAM)" off
     36 "qwen2.5 32b-instruct-fp16 (x,x GB en disco) (x,x GB en VRAM)" off

     37 "qwen2.5 72b-instruct-q4_0 (x,x GB en disco) (x,x GB en VRAM)" off
     38 "qwen2.5 72b-instruct-q8_0 (x,x GB en disco) (x,x GB en VRAM)" off
     39 "qwen2.5 72b-instruct-fp16 (x,x GB en disco) (x,x GB en VRAM)" off

     40 "mistral 7b-instruct-q4_0 ( 4,2 GB en disco) ( 7,2 GB en VRAM)" off
     41 "mistral 7b-instruct-q8_0 ( 7,8 GB en disco) (15,0 GB en VRAM)" off
     42 "mistral 7b-instruct-fp16 (14,2 GB en disco) ( x,x GB en VRAM)?" off

     43 "phi3 3.8b-mini-128k-instruct-q4_0 (x,x GB en disco) (x,x GB en VRAM)" off
     44 "phi3 3.8b-mini-128k-instruct-q8_0 (x,x GB en disco) (x,x GB en VRAM)" off
     45 "phi3 3.8b-mini-128k-instruct-fp16 (x,x GB en disco) (x,x GB en VRAM)" off

     46 "phi3 14b-medium-128k-instruct-q4_0 (x,x GB en disco) (x,x GB en VRAM)" off
     47 "phi3 14b-medium-128k-instruct-q8_0 (x,x GB en disco) (x,x GB en VRAM)" off
     48 "phi3 14b-medium-128k-instruct-fp16 (x,x GB en disco) (x,x GB en VRAM)" off
     
     49 "deepseek-coder-v2 16b-lite-instruct-q4_0 (x,x GB en disco) (x,x GB en VRAM)" off
     50 "deepseek-coder-v2 16b-lite-instruct-q8_0 (x,x GB en disco) (x,x GB en VRAM)" off
     51 "deepseek-coder-v2 16b-lite-instruct-fp16 (x,x GB en disco) (x,x GB en VRAM)" off
     
     52 "deepseek-coder-v2 236b-instruct-q4_0 (x,x GB en disco) (x,x GB en VRAM)" off
     53 "deepseek-coder-v2 236b-instruct-q8_0 (x,x GB en disco) (x,x GB en VRAM)" off
     54 "deepseek-coder-v2 236b-instruct-fp16 (x,x GB en disco) (x,x GB en VRAM)" off
     
     55 "gemma2 9b-instruct-q4_0 (x,x GB en disco) (x,x GB en VRAM)" off
     56 "gemma2 9b-instruct-q8_0 (x,x GB en disco) (x,x GB en VRAM)" off
     57 "gemma2 9b-instruct-fp16 (x,x GB en disco) (x,x GB en VRAM)" off
     
     58 "gemma2 27b-instruct-q4_0 (x,x GB en disco) (x,x GB en VRAM)" off
     59 "gemma2 27b-instruct-q8_0 (x,x GB en disco) (x,x GB en VRAM)" off
     60 "gemma2 27b-instruct-fp16 (x,x GB en disco) (x,x GB en VRAM)" off

    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "  Instalando llama3.2:1b..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=2
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull llama3.2:1b
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.2:1b.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          2)

            echo ""
            echo "  Instalando llama3.2:3b..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=3
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull llama3.2:3b
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.2:3b.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          3)

            echo ""
            echo "  Instalando llama3.2:1b-instruct-fp16..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=3
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull llama3.2:1b-instruct-fp16
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.2:1b-instruct-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          4)

            echo ""
            echo "  Instalando llama3.2:3b-instruct-fp16..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=7
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull llama3.2:3b-instruct-fp16
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.2:3b-instruct-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          5)

            echo ""
            echo "  Instalando llama3.1:8b..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=6
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull llama3.1:8b
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.1:8b.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          6)

            echo ""
            echo "  Instalando llama3.1:70b..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=42
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull llama3.1:70b
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.1:70b.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          7)

            echo ""
            echo "  Instalando llama3.1:8b-instruct-fp16..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=18
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull llama3.1:8b-instruct-fp16
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.1:8b-instruct-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          8)

            echo ""
            echo "  Instalando llama3.1 70b-instruct-fp16..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=145
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull llama3.1:70b-instruct-fp16
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.1:70b-instruct-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          9)

            echo ""
            echo "  Instalando mistral:7b..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=6
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull mistral:7b
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo mistral:7b.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         10)

            echo ""
            echo "  Instalando mistral:7b-instruct-fp16..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=16
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull mistral:7b-instruct-fp16
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo mistral:7b-instruct-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         11)

            echo ""
            echo "  Instalando phi3:3.8b..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=3
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull phi3:3.8b
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo phi3:3.8b.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         12)

            echo ""
            echo "  Instalando phi3:14b..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=9
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull phi3:14b
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo phi3:14b.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         13)

            echo ""
            echo "  Instalando phi3:3.8b-mini-128k-instruct-f16..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=9
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull phi3:3.8b-mini-128k-instruct-f16
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo phi3:3.8b-mini-128k-instruct-f16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         14)

            echo ""
            echo "  Instalando phi3:14b-medium-128k-instruct-f16..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=30
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull phi3:14b-medium-128k-instruct-f16
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo phi3:14b-medium-128k-instruct-f16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         15)

            echo ""
            echo "  Instalando deepseek-coder-v2:16b..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=10
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull deepseek-coder-v2:16b
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo deepseek-coder-v2:16b.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         16)

            echo ""
            echo "  Instalando deepseek-coder-v2:236b..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=135
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull deepseek-coder-v2:236b
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo deepseek-coder-v2:236b.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         17)

            echo ""
            echo "  Instalando deepseek-coder-v2:16b-lite-instruct-fp16..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=33
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull deepseek-coder-v2:16b-lite-instruct-fp16
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo deepseek-coder-v2:16b-lite-instruct-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         18)

            echo ""
            echo "  Instalando deepseek-coder-v2:236b-instruct-fp16..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=480
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull deepseek-coder-v2:236b-instruct-fp16
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo deepseek-coder-v2:236b-instruct-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;


         19)

            echo ""
            echo "  Instalando gemma2:9b..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=6
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull gemma2:9b
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo gemma2:9b.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         20)

            echo ""
            echo "  Instalando gemma2:27b..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=18
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull gemma2:27b
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo gemma2:27b.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         21)

            echo ""
            echo "  Instalando gemma2:9b-instruct-fp16..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=20
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull gemma2:9b-instruct-fp16
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo gemma2:9b-instruct-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         22)

            echo ""
            echo "  Instalando gemma2:27b-instruct-fp16..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=56
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull gemma2:27b-instruct-fp16
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo gemma2:27b-instruct-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

      esac

  done
