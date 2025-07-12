#!/bin/bash

# Comprobar que el script se haya ejecutado con el usuario oracle
  vUsuario=$(id | cut -d"(" -f2 | cut -d ")" -f1)
  echo $vUsuario
  if [ $vUsuario != "oracle" ]; then
    echo "El script debe ser ejecutado como el usuario oracle. Abortando script..."    exit 1
  fi

vCarpetaCopSeg=/home/oracle/CopSeg/Inconsistente/Incremental
mkdir -p $vCarpetaCopSeg 2> /dev/null
export DATE=$(date +A%yM%mD%d-%H%M%S)

#rman target / log=/home/oracle/CopSeg/prueba.log << EOF
rman target / << EOF
run {
backup incremental level 0 database format            '$vCarpetaCopSeg/%d-${DATE}-database_%u';
backup incremental level 0 archivelog all format      '$vCarpetaCopSeg/%d-${DATE}-archivelogs_%u' delete input;
backup incremental level 0 current controlfile format '$vCarpetaCopSeg/%d-${DATE}-controlfile_%u';
}
exit;
EOF

