#!/usr/bin/env bash
# Construye con Java 8, 11, 17 y 21 y confirma que la CA quedó importada.
# Uso: ./probar-versiones.sh   (con Podman: DOCKER=podman ./probar-versiones.sh)
set -euo pipefail
cd "$(dirname "$0")"
DOCKER=${DOCKER:-docker}
[ -f certs/MiRootCA.crt ] || ./generar-ca.sh
for v in 8 11 17 21; do
  echo "== Java $v =="
  echo -n "ingenuo (ruta fija): "
  if $DOCKER build -q -f Dockerfile.ingenuo --build-arg BASE_IMAGE=eclipse-temurin:$v-jdk -t cacerts-ingenuo:$v . >/dev/null 2>&1; then
    echo "OK"; else echo "FALLA"; fi
  $DOCKER build -q --build-arg BASE_IMAGE=eclipse-temurin:$v-jdk -t cacerts-demo:$v . >/dev/null
  $DOCKER run --rm cacerts-demo:$v | grep -i 'mirootca' || { echo "no se encontró la CA"; exit 1; }
done
