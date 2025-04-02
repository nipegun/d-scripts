#!/bin/bash
# Clona imágenes, volúmenes y opcionalmente contenedores Docker activos
# Autor: ChatGPT para NiPeGun

set -e

FECHA=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="docker_backup_$FECHA"
IMAGES_DIR="$BACKUP_DIR/imágenes"
VOLUMES_DIR="$BACKUP_DIR/volúmenes"
CONTAINERS_DIR="$BACKUP_DIR/contenedores"

mkdir -p "$IMAGES_DIR" "$VOLUMES_DIR"

echo "[+] Exportando imágenes..."
docker ps -a --format '{{.Image}}' | sort | uniq | while read image; do
  safe_name="${image//[:\/]/_}"
  echo "  -> $image"
  docker save "$image" -o "$IMAGES_DIR/$safe_name.tar"
done

echo "[+] Exportando volúmenes..."
docker volume ls -q | while read vol; do
  echo "  -> $vol"
  docker run --rm -v "$vol":/vol -v "$(pwd)/$VOLUMES_DIR":/backup alpine \
    sh -c "cd /vol && tar czf /backup/${vol}.tar.gz ."
done

read -p "[?] ¿Querés exportar también los contenedores en ejecución (solo filesystem)? [s/N]: " opc
if [[ "$opc" =~ ^[sS]$ ]]; then
  mkdir -p "$CONTAINERS_DIR"
  echo "[+] Exportando contenedores activos..."
  docker ps -q | while read cid; do
    name=$(docker inspect --format '{{.Name}}' "$cid" | sed 's/\///g')
    echo "  -> $name"
    docker export "$cid" -o "$CONTAINERS_DIR/${name}_fs.tar"
  done
fi

echo "[+] Backup completo en: $BACKUP_DIR"
echo "=> Ahora podés copiar la carpeta al portátil con scp o rsync."
echo "scp *.tar user@portatil:/ruta/destino"
echo "scp -r volumes_backup user@portatil:/ruta/destino"
exho ""
