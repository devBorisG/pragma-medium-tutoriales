#!/usr/bin/env bash
# Genera una CA de prueba (no es de ninguna empresa) en certs/MiRootCA.crt
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p certs
openssl req -x509 -newkey rsa:2048 -nodes -days 365 \
  -subj "/CN=MiRootCA de prueba/O=Demo" \
  -keyout certs/MiRootCA.key -out certs/MiRootCA.crt
echo "CA generada en certs/MiRootCA.crt"
