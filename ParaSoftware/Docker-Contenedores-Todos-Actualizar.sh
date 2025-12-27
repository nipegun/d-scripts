#!/bin/bash

# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/Docker-Contenedores-Todos-Actualizar.sh | bash

set -e

vContenedores=$(sudo docker ps -q)

if [ -z "$vContenedores" ]; then
  echo "No hay contenedores en ejecución."
  exit 0
fi

echo "Analizando contenedores en ejecución..."

for vContainer in $vContenedores; do
  vNombre=$(sudo docker inspect --format '{{.Name}}' "$vContainer" | sed 's#^/##')
  vProyectoCompose=$(sudo docker inspect --format '{{ index .Config.Labels "com.docker.compose.project" }}' "$vContainer" 2>/dev/null || true)

  if [ -n "$vProyectoCompose" ]; then
    vWorkingDir=$(sudo docker inspect --format '{{ index .Config.Labels "com.docker.compose.project.working_dir" }}' "$vContainer")

    echo "Actualizando stack docker-compose: $vProyectoCompose"
    cd "$vWorkingDir"
    sudo docker compose pull
    sudo docker compose up -d
  else
    echo "Saltando contenedor NO gestionado por docker-compose: $vNombre"
    echo "Motivo: no se puede recrear sin el docker run original"
  fi
done

echo "Proceso finalizado."
