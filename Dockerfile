FROM tomcat:10.1-jdk17

WORKDIR /usr/local/tomcat/webapps

COPY Online_Banking_System.war ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]