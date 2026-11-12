# 09 · Un Dockerfile que encuentra cacerts en cualquier versión de Java

Importa una CA propia al truststore de la JVM sin escribir la ruta de `cacerts` a mano.

## Requisitos

- Docker o Podman.
- `openssl` (para generar una CA de prueba).

> **Windows:** ejecuta todo en Git Bash. Con Podman: `export DOCKER=podman` antes de los scripts. `openssl` ya viene con Git for Windows. Preparación completa en el [README raíz](../README.md#windows-git-bash-y-podman).

## Pasos

```bash
./generar-ca.sh                 # crea certs/MiRootCA.crt (CA de prueba, no es de ninguna empresa)
./probar-versiones.sh           # con Podman: DOCKER=podman ./probar-versiones.sh
```

El script construye dos imágenes por cada versión de Java (8, 11, 17 y 21):

- `Dockerfile.ingenuo`: ruta fija `$JAVA_HOME/lib/security/cacerts`.
- `Dockerfile`: le pregunta a la JVM su `java.home`, resuelve enlaces con `readlink -f` y tiene rutas de respaldo.

## Resultado esperado

Con `Dockerfile`, en las cuatro versiones el log del build muestra `Using cacerts: <ruta>` y el contenedor imprime:

```
MiRootCA, <fecha>, trustedCertEntry,
```

Con `Dockerfile.ingenuo`, fíjate en qué versión falla el build. Ojo: si la carpeta existe pero el archivo no,
`keytool` crea un keystore nuevo en esa ruta **y no falla**; la JVM nunca lo lee. Por eso el `Dockerfile` bueno
imprime la ruta que usó.

## Ejemplo del enlace simbólico

En un Ubuntu con `openjdk-21-jdk`, la detección resuelve:

```
Using cacerts: /etc/ssl/certs/java/cacerts
```

`$JAVA_HOME/lib/security/cacerts` es un enlace al truststore del sistema operativo.

## Alternativa en Java 9+

```bash
keytool -importcert -cacerts -storepass changeit -noprompt -alias MiRootCA -file MiRootCA.crt
```

## Limpieza

```bash
for v in 8 11 17 21; do docker rmi cacerts-demo:$v cacerts-ingenuo:$v 2>/dev/null; done
rm -rf certs
```
