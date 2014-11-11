FROM tutum/tomcat:8.0
ENV WEBAPP_HOME $CATALINA_HOME/webapps/ROOT
RUN apt-get update && apt-get install -y unzip curl postgresql
RUN rm -rf $CATALINA_HOME/webapps/ROOT

ENV REPO http://localhost:8000/repository/snapshots/
ENV VERSION 2.2.2-SNAPSHOT

# Get the war
RUN curl -sSL -o /tomcat/webapps/ROOT.war $REPO/org/appfuse/appfuse-spring/$VERSION/appfuse-spring-$VERSION.war \
  && mkdir -p $CATALINA_HOME/webapps/ROOT \
  && cd $CATALINA_HOME/webapps/ROOT \
  && unzip ../ROOT.war \
  && rm ../ROOT.war

# get the postgresql jdbc jar
RUN curl -sSL -o $WEBAPP_HOME/WEB-INF/lib/postgresql-9.1-901.jdbc4.jar http://repo1.maven.org/maven2/postgresql/postgresql/9.1-901.jdbc4/postgresql-9.1-901.jdbc4.jar

# configure the db connection and copy sql init file
COPY jdbc.properties $WEBAPP_HOME/WEB-INF/classes/
COPY dump.sql /
COPY run.sh /
