#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------------------------
#  Script De NiPeGun para saber en que puesto se sienta un usuario cuyo NickName ya conocemos
#----------------------------------------------------------------------------------------------

# Argumentos necesarios para pasarle al script
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
    echo -e "El uso correcto sería: DondeSeSienta ${ColorArgumentos}[NickName] [NroArabaEncounter]${FinColor}"
    echo ""
    echo "Ejemplo 1: DondeSeSienta Zordor 04"
    echo ""
    echo "Ejemplo 2: DondeSeSienta zordor 04"
    echo ""
    echo "-------------------------------------------------------------------------"
    echo ""
    exit $ArgsInsuficientes
  else
    # --------------------------------------------------------------------------------------
    # --------------------------------------------------------------------------------------

    echo ""
    echo "PROCESANDO..."
    echo ""
    for Fila in {A..J}
      do
        for Columna in {1..32}
          do

            NickName=$(curl -s https://eps.encounter.eus/ae$2/map/lookup/$Fila"_"$Columna | jq -r '.user')

            # Mostrar, línea a línea, cada usuario procesado.
            echo $Fila"_"$Columna":"$NickName

            # Comprobar si el nombre de usuario hallado corresponde con el proporcionado como parámetro
            if [ $NickName = $1 ]; then

              Puesto=$(curl -s https://eps.encounter.eus/ae$2/map/lookup/$Fila"_"$Columna | jq -r '.seat')
              echo ""
              echo "$NickName se sienta en el puesto $Puesto"
              echo ""

              # Terminar el script
              exit 1

            fi

          # Esperar 5 segundos hasta hacer otra vez la consulta curl
          sleep 5

          done
      done

    # --------------------------------------------------------------------------------------
    # --------------------------------------------------------------------------------------


fi

