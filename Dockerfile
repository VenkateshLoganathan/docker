# Dockerfile is used to deploy the Game of life application from the artifactory server to the Jetty webserver.

# Author: Venkatesh.L

# Download the lastest Jetty version
FROM jetty:latest

# Create the root user and run the commands as user root.
USER root

# Update the apt repository and install the required packages.
RUN apt-get -y update && apt-get -y install vim net-tools wget

# Download the GameofLife application artifacts from the artifactory server.
RUN wget -nH -np --cut-dir=7 --recursive -R "index.html.*" -R "index.html" http://172.17.1.22:8081/artifactory/libs-release-local/com/wakaleo/gameoflife/gameoflife-web/1.0.0/ -P /var/lib/jetty/webapps/

# Start the Jetty service.
RUN java -jar "$JETTY_HOME/start.jar" &

# Publish the Jetty service port.
EXPOSE 8080
