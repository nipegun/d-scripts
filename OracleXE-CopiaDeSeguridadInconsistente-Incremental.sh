#!/bin/bash

# Comprobar que el script se haya ejecutado con el usuario oracle
  vUsuario=$(id | cut -d"(" -f2 | cut -d ")" -f1)
  echo $vUsuario
  if [ $vUsuario != "oracle" ]; then
    echo "El script debe ser ejecutado como el usuario oracle. Abortando script..."
    exit 1
  fi

vCarpetaCopSeg=/home/oracle/CopSeg
mkdir -p $vCarpetaCopSeg 2> /dev/null
export DATE=$(date +A%yM%mD%d-%H%M%S)

#rman target / log=/home/oracle/CopSeg/prueba.log << EOF
rman target / << EOF
run {
backup as compressed backupset incremental level 0 database tag 'CopiaInconsistenteIncremental' plus archivelog tag 'CopiaInconsistenteIncremental';
}
exit;
EOF

