# Imagen base configurable para probar varias versiones de Java:
#   docker build --build-arg BASE_IMAGE=eclipse-temurin:8-jdk -t cacerts-demo:8 .
ARG BASE_IMAGE=eclipse-temurin:21-jdk
FROM ${BASE_IMAGE}

COPY certs/MiRootCA.crt /tmp/MiRootCA.crt

# 1. Pregunta a la JVM su java.home real.
# 2. Resuelve enlaces simbólicos con readlink -f.
# 3. Si no existe, prueba las rutas clásicas (Java 8 con jre/ y Java 9+).
RUN CACERTS="$(readlink -f "$($JAVA_HOME/bin/java -XshowSettings:properties -version 2>&1 \
      | awk -F'= ' '/java.home/{print $2}')/lib/security/cacerts")" && \
    if [ ! -f "$CACERTS" ]; then CACERTS="$JAVA_HOME/jre/lib/security/cacerts"; fi && \
    if [ ! -f "$CACERTS" ]; then CACERTS="$JAVA_HOME/lib/security/cacerts"; fi && \
    echo "Using cacerts: $CACERTS" && \
    $JAVA_HOME/bin/keytool -noprompt -import -trustcacerts -keystore "$CACERTS" \
      -storepass changeit -alias MiRootCA -file /tmp/MiRootCA.crt && \
    rm /tmp/MiRootCA.crt

# Al arrancar, muestra que la CA quedó en el truststore que usa la JVM
CMD ["sh", "-c", "$JAVA_HOME/bin/keytool -list -keystore \"$(readlink -f \"$($JAVA_HOME/bin/java -XshowSettings:properties -version 2>&1 | awk -F'= ' '/java.home/{print $2}')/lib/security/cacerts\")\" -storepass changeit -alias MiRootCA 2>/dev/null || $JAVA_HOME/bin/keytool -list -keystore $JAVA_HOME/jre/lib/security/cacerts -storepass changeit -alias MiRootCA"]
