FROM eclipse-temurin:17-jdk

MAINTAINER Jeff Evans <jeff.evans@metabase.com>

ENV PRESTO_VERSION 0.295

# the Presto launcher script needs Python
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends python-is-python3 && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /opt/presto && \
    curl -LS https://repo1.maven.org/maven2/com/facebook/presto/presto-server/${PRESTO_VERSION}/presto-server-${PRESTO_VERSION}.tar.gz | tar -xz --strip-components=1 -C /opt/presto

# the executable CLI jar is not on Maven Central for newer versions
RUN curl -fLo /usr/local/bin/presto https://github.com/prestodb/presto/releases/download/${PRESTO_VERSION}/presto-cli-${PRESTO_VERSION}-executable.jar && \
    chmod +x /usr/local/bin/presto

COPY ["./etc", "/opt/presto/etc"]

RUN keytool \
        -genkeypair \
        -alias "presto" \
        -keyalg RSA \
        -keystore /opt/presto/etc/keystore.jks \
        -validity 10000 \
        -dname "CN=*.presto-ci.metabase.com, OU=Engineering, O=Metabase, L=San Francisco, S=CA, C=USA" \
        -ext "SAN:c=DNS:localhost,IP:127.0.0.1,DNS:presto" \
        -storepass metabase

EXPOSE 8080 8443

CMD ["/opt/presto/bin/launcher", "run"]
