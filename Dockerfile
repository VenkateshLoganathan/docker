# Dockerfile is used to deploy the Game of life application from the artifactory server to the Jetty webserver.

# Author: Venkatesh.L

# Download the lastest Jetty version
FROM jetty:latest

# Create the root user and run the commands as user root.
USER root

# Update the apt repository and install the required packages.
RUN apt-get -y update && apt-get -y install vim net-tools wget libxml2-utils

# Download the metadata xml file to identify the latest version
RUN wget -nH -np --cut-dir=7 --recursive -R "index.html.*" -R "index.html" http://172.17.1.22:8081/artifactory/libs-release-local/com/wakaleo/gameoflife/gameoflife-web/maven-metadata.xml && release_version="$(cat maven-metadata.xml | tr '\n' ' ' | XMLLINT_INDENT="" xmllint --format - | grep -e "<latest>" | cut -d'>' -f2 | cut -d'<' -f1)" && wget -nH -np --cut-dir=7 --recursive -R "index.html.*" -R "index.html" http://172.17.1.22:8081/artifactory/libs-release-local/com/wakaleo/gameoflife/gameoflife-web/$release_version/ -P /var/lib/jetty/webapps/

# Start the Jetty service.
RUN java -jar "$JETTY_HOME/start.jar" &

# Publish the Jetty service port.
EXPOSE 8080
