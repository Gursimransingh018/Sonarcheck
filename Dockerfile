FROM tomcat 
WORKDIR webapps 
COPY target/MyWebApp.war .
RUN rm -rf ROOT && mv MyWebApp.war ROOT.war
ENTRYPOINT ["sh", "/usr/local/tomcat/bin/startup.sh"]
