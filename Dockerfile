FROM jboss/wildfly:18.0.0.Final
LABEL app.autor="José Renato Fagundes da Silva Júnior"
LABEL app.email="juniorfagundes@gmail.com"
LABEL app.name="myapp"

ENV WILDFLY_HOME /opt/jboss/wildfly
ENV DEPLOY_DIR ${WILDFLY_HOME}/standalone/deployments/

# setup timezone
ENV TZ=America/Sao_Paulo
USER root
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
USER jboss

ENV DATASOURCE_NAME ApplicationDS
ENV DATASOURCE_JNDI java:/ApplicationDS

ENV DB_HOST database
ENV DB_PORT 5432
ENV DB_USER user
ENV DB_PASS password
ENV DB_NAME dbname

# create temporary deployment dir, because wars can deploy after the datasource is created
RUN mkdir /tmp/deploments
ENV DEPLOY_DIR /tmp/deploments

RUN mkdir /tmp/jboss-cli
ENV CLI_DIR /tmp/jboss-cli

COPY startWildflyWithPostgres.sh $WILDFLY_HOME/bin

USER root
RUN chown jboss:jboss $WILDFLY_HOME/bin/startWildflyWithPostgres.sh
RUN chmod 755 $WILDFLY_HOME/bin/startWildflyWithPostgres.sh
USER jboss

COPY postgresql-42.2.8.jar /tmp

ENTRYPOINT $WILDFLY_HOME/bin/startWildflyWithPostgres.sh