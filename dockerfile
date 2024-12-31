# Base OpenJDK
FROM eclipse-temurin:21-jdk-noble

#  Install supervisorD to control the services
RUN apt-get update && apt-get install -y supervisor && rm -rf /var/lib/apt/lists/*

# Creating the base directories
RUN mkdir -p /opt/backend /var/log/supervisor

# Config for server (JAR SPRING)
COPY server/target/server.jar /opt/backend/
WORKDIR /opt/backend
RUN chmod +x /opt/backend/server.jar

# Config for Tomcat Environment
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

# Download and setup tomcat 
RUN curl -fSL "https://dlcdn.apache.org/tomcat/tomcat-11/v11.0.2/bin/apache-tomcat-11.0.2.tar.gz" -o tomcat.tar.gz \
    && tar -xzf tomcat.tar.gz --strip-components=1 \
    && rm tomcat.tar.gz \
    && chmod -R +rX $CATALINA_HOME


# Copying the tomcat local configs
COPY tomcat/bin $CATALINA_HOME/bin
COPY tomcat/conf $CATALINA_HOME/conf


# do the deploy of all aps
COPY web/target/*.war $CATALINA_HOME/webapps/

# Copying the supervisord services configs
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Exposing the ports for server and tomcat
EXPOSE 8080 8081

# Starting supervisord service
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
