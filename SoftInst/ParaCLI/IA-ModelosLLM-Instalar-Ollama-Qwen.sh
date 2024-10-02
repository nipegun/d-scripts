#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar los diferentes modelos de Qwen en Ollama para Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/IA-ModelosLLM-Instalar-Ollama-Qwen.sh | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/IA-ModelosLLM-Instalar-Ollama-Qwen.sh | bash
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
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de modelos LLM de Qwen para Ollama...${cFinColor}"
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

      1 "qwen2.5 0.5-instruct-q4_0 (x,x GB en disco) (x,x GB en VRAM)" off
      2 "qwen2.5 0.5-instruct-q8_0 (x,x GB en disco) (x,x GB en VRAM)" off
      3 "qwen2.5 0.5-instruct-fp16 (x,x GB en disco) (x,x GB en VRAM)" off

      4 "qwen2.5 1.5-instruct-q4_0 (x,x GB en disco) (x,x GB en VRAM)" off
      5 "qwen2.5 1.5-instruct-q8_0 (x,x GB en disco) (x,x GB en VRAM)" off
      6 "qwen2.5 1.5-instruct-fp16 (x,x GB en disco) (x,x GB en VRAM)" off
     
      7 "qwen2.5 3b-instruct-q4_0 (x,x GB en disco) (x,x GB en VRAM)" off
      8 "qwen2.5 3b-instruct-q8_0 (x,x GB en disco) (x,x GB en VRAM)" off
      9 "qwen2.5 3b-instruct-fp16 (x,x GB en disco) (x,x GB en VRAM)" off

     10 "qwen2.5 7b-instruct-q4_0 (x,x GB en disco) (x,x GB en VRAM)" off
     11" qwen2.5 7b-instruct-q8_0 (x,x GB en disco) (x,x GB en VRAM)" off
     12 "qwen2.5 7b-instruct-fp16 (x,x GB en disco) (x,x GB en VRAM)" off

     13 "qwen2.5 14b-instruct-q4_0 (x,x GB en disco) (x,x GB en VRAM)" off
     14 "qwen2.5 14b-instruct-q8_0 (x,x GB en disco) (x,x GB en VRAM)" off
     15 "qwen2.5 14b-instruct-fp16 (x,x GB en disco) (x,x GB en VRAM)" off

     16 "qwen2.5 32b-instruct-q4_0 (x,x GB en disco) (x,x GB en VRAM)" off
     17 "qwen2.5 32b-instruct-q8_0 (x,x GB en disco) (x,x GB en VRAM)" off
     18 "qwen2.5 32b-instruct-fp16 (x,x GB en disco) (x,x GB en VRAM)" off

     19 "qwen2.5 72b-instruct-q4_0 (x,x GB en disco) (x,x GB en VRAM)" off
     20 "qwen2.5 72b-instruct-q8_0 (x,x GB en disco) (x,x GB en VRAM)" off
     21 "qwen2.5 72b-instruct-fp16 (x,x GB en disco) (x,x GB en VRAM)" off

    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "  Instalando llama3.2:1b-instruct-q4_0..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=2
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull llama3.2:1b-instruct-q4_0
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.2:1b-instruct-q4_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          2)

            echo ""
            echo "  Instalando llama3.2:1b-instruct-q8_0..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=2
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull llama3.2:1b-instruct-q8_0
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.2:1b-instruct-q8_0.${cFinColor}"
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
              vGBsLibresNecesarios=2
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
            echo "  Instalando llama3.2:3b-instruct-q4_0..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=2
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull llama3.2:3b-instruct-q4_0
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.2:3b-instruct-q4_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          5)

            echo ""
            echo "  Instalando llama3.2:3b-instruct-q8_0..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=2
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull llama3.2:3b-instruct-q8_0
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.2:3b-instruct-q8_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          6)

            echo ""
            echo "  Instalando llama3.2:3b-instruct-fp16..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=2
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

          7)

            echo ""
            echo "  Instalando llama3.1:8b-instruct-q4_0 ..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=2
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull llama3.1:8b-instruct-q4_0 
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.1:8b-instruct-q4_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          8)

            echo ""
            echo "  Instalando llama3.1:8b-instruct-q8_0..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=2
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull llama3.1:8b-instruct-q8_0
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.1:8b-instruct-q8_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          9)

            echo ""
            echo "  Instalando llama3.1:8b-instruct-fp16..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=2
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

         10)

            echo ""
            echo "  Instalando llama3.1:70b-instruct-q4_0..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=2
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull llama3.1:70b-instruct-q4_0
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.1:70b-instruct-q4_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         11)

            echo ""
            echo "  Instalando llama3.1:70b-instruct-q8_0..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=2
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull llama3.1:70b-instruct-q8_0
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.1:70b-instruct-q8_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         12)

            echo ""
            echo "  Instalando llama3.1:70b-instruct-fp16..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=2
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

         13)

            echo ""
            echo "  Instalando llama3.1:405b-instruct-q4_0..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=2
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull llama3.1:405b-instruct-q4_0
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.1:405b-instruct-q4_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         14)

            echo ""
            echo "  Instalando llama3.1:405b-instruct-q8_0..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=2
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull llama3.1:405b-instruct-q8_0
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.1:405b-instruct-q8_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         15)

            echo ""
            echo "  llama3.1:405b-instruct-fp16..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=2
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull llama3.1:405b-instruct-fp16
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.1:405b-instruct-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

      esac

  done
