FROM tutum/tomcat:8.0

ENV WEBAPP_HOME $CATALINA_HOME/webapps/ROOT

RUN apt-get update && apt-get install -y unzip curl postgresql

RUN rm -rf $CATALINA_HOME/webapps/ROOT

ENV REPO http://central.maven.org/maven2

RUN curl -sSL -o /tomcat/webapps/ROOT.war $REPO/org/appfuse/appfuse-spring/2.2.1/appfuse-spring-2.2.1.war \
  && mkdir -p $CATALINA_HOME/webapps/ROOT \
  && cd $CATALINA_HOME/webapps/ROOT \
  && unzip ../ROOT.war \
  && rm ../ROOT.war

RUN curl -sSL -o $WEBAPP_HOME/WEB-INF/lib/postgresql-9.1-901.jdbc4.jar http://repo1.maven.org/maven2/postgresql/postgresql/9.1-901.jdbc4/postgresql-9.1-901.jdbc4.jar

COPY jdbc.properties $WEBAPP_HOME/WEB-INF/classes/

COPY dump.sql /

COPY run.sh /
