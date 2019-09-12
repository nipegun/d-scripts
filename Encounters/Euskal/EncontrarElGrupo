#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#---------------------------------------------------------------------------------------------------
#  Script De NiPeGun para encontrar un grupo de la EuskalEncounter cuyo nombre exacto ya conocemos
#---------------------------------------------------------------------------------------------------

# Argumentos del script
CantArgsCorrectos=2
ArgsInsuficientes=65

# Color para las advertencias
ColorAdvertencia='\033[1;31m'
ColorArgumentos='\033[1;32m'
FinColor='\033[0m'

# Comprobar que se hayan pasado los argumentos necesarios. Si no, advertir y salir del script
if [ $# -ne $CantArgsCorrectos ]

  then

    echo ""
    echo "-------------------------------------------------------------------------"
    echo -e "${ColorAdvertencia}Mal uso del script!!${FinColor}"
    echo ""
    echo -e "El uso correcto sería: EncontrarElGrupo ${ColorArgumentos}[Grupo] [NroEuskalEncounter]${FinColor}"
    echo ""
    echo "Ejemplo 1: EncontrarElGrupo VidasEnRed 25"
    echo ""
    echo "Ejemplo 2: EncontrarElGrupo Vidasenred 25"
    echo ""
    echo "-------------------------------------------------------------------------"
    echo ""
    exit $ArgsInsuficientes

  else

    echo ""
    echo "  Buscando el grupo $1 en la EuskalEncounter $2"...

    echo ""
    echo "Procesando la zona A..."
    echo ""
    for FilaZonaA in {A..T}
      do
        for ColumnaZonaA in {1..128}
          do

            Grupo=$(curl -s https://eps.encounter.eus/ee$2/map/lookup/A$FilaZonaA"_"$ColumnaZonaA | jq -r '.group')

            # Mostrar, línea a línea, cada puesto procesado.
            echo A$FilaZonaA"_"$ColumnaZonaA":" $Grupo

            # Comprobar si el nombre del grupo hallado corresponde con el proporcionado como parámetro
            if [ $Grupo = $1 ]; then

              echo ""
              echo "Podrás saber que puestos tiene asignados el grupo $Grupo"
              echo "si vas al mapa de puestos y haces click en el A$FilaZonaA$ColumnaZonaA"
              echo ""

              # Terminar el script
              exit 1

            fi

          # Esperar 5 segundos hasta hacer otra vez la consulta curl
          sleep 5

          done
      done

    echo ""
    echo "Procesando la zona B..."
    echo ""
    for FilaZonaB in {A..T}
      do
        for ColumnaZonaB in {1..128}
          do

            Grupo=$(curl -s https://eps.encounter.eus/ee$2/map/lookup/B$FilaZonaB"_"$ColumnaZonaB | jq -r '.group')

            # Mostrar, línea a línea, cada puesto procesado.
            echo B$FilaZonaB"_"$ColumnaZonaB":" $Grupo

            # Comprobar si el nombre del grupo hallado corresponde con el proporcionado como parámetro
            if [ $Grupo = $1 ]; then

              echo ""
              echo "Podrás saber que puestos tiene asignados el grupo $Grupo"
              echo "si vas al mapa de puestos y haces click en el B$FilaZonaB$ColumnaZonaB"
              echo ""

              # Terminar el script
              exit 1

            fi

          # Esperar 5 segundos hasta hacer otra vez la consulta curl
          sleep 5

          done
      done

fi

