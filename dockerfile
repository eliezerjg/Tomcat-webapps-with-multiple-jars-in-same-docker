# Base OpenJDK
FROM eclipse-temurin:21-jdk-noble

# Instalar o supervisor
RUN apt-get update && apt-get install -y supervisor && rm -rf /var/lib/apt/lists/*

# Criar diretórios necessários
RUN mkdir -p /opt/backend /var/log/supervisor

# Configurar o servidor Java
COPY server/target/server.jar /opt/backend/
WORKDIR /opt/backend
RUN chmod +x /opt/backend/server.jar

# Configurar o Tomcat
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

# Baixar e configurar Tomcat
RUN curl -fSL "https://dlcdn.apache.org/tomcat/tomcat-11/v11.0.2/bin/apache-tomcat-11.0.2.tar.gz" -o tomcat.tar.gz \
    && tar -xzf tomcat.tar.gz --strip-components=1 \
    && rm tomcat.tar.gz \
    && chmod -R +rX $CATALINA_HOME


# Copiar as configurações do Tomcat
COPY tomcat/bin $CATALINA_HOME/bin
COPY tomcat/conf $CATALINA_HOME/conf


# Faz deploy de todos wars
COPY web/target/*.war $CATALINA_HOME/webapps/

# Configurar supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expor as portas
EXPOSE 8080 8081

# Comando de inicialização do supervisord
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
