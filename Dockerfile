FROM tomcat:8.0.20-jre8
COPY target/web-project*.war /usr/local/tomcat/webapps/web-project.war
