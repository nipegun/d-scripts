#!/bin/bash
# Restaura imágenes y volúmenes Docker desde un backup creado con clonar_dockers.sh
# Autor: ChatGPT para NiPeGun

# Uso:
# chmod +x restaurar_dockers.sh
# ./restaurar_dockers.sh docker_backup_20250402_1530


set -e

BACKUP_DIR="$1"

if [ -z "$BACKUP_DIR" ] || [ ! -d "$BACKUP_DIR" ]; then
  echo "[!] Usá: $0 <directorio_backup>"
  exit 1
fi

IMAGES_DIR="$BACKUP_DIR/imágenes"
VOLUMES_DIR="$BACKUP_DIR/volúmenes"
CONTAINERS_DIR="$BACKUP_DIR/contenedores"

echo "[+] Restaurando imágenes..."
cd "$IMAGES_DIR"
for img in *.tar; do
  echo "  -> $img"
  docker load -i "$img"
done

echo "[+] Restaurando volúmenes..."
cd "$VOLUMES_DIR"
for voltar in *.tar.gz; do
  volname="${voltar%.tar.gz}"
  echo "  -> $volname"
  docker volume create "$volname"
  docker run --rm -v "$volname":/vol -v "$(pwd)":/backup alpine \
    sh -c "cd /vol && tar xzf /backup/$voltar"
done

if [ -d "$CONTAINERS_DIR" ]; then
  echo "[?] Se detectaron contenedores exportados. ¿Querés importarlos (solo filesystem)?"
  read -p "    Esto no los ejecuta, solo importa el sistema de archivos. [s/N]: " opc
  if [[ "$opc" =~ ^[sS]$ ]]; then
    cd "$CONTAINERS_DIR"
    for cfile in *_fs.tar; do
      name="${cfile%_fs.tar}"
      echo "  -> Importando como imagen: $name"
      docker import "$cfile" "$name:imported"
    done
  fi
fi

echo "[✓] Restauración completa. Ahora podés usar docker run o docker-compose para lanzar tus contenedores."
