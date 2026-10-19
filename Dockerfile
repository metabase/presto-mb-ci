FROM prestodb/presto:0.295

RUN rm -rf /opt/presto-server/etc && \
    ln -s /opt/presto-server /opt/presto && \
    ln -s /usr/local/bin/presto-cli /usr/local/bin/presto

COPY ["./etc", "/opt/presto-server/etc"]

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
