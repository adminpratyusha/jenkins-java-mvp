# Use an official Tomcat runtime as a parent image
FROM tomcat:9-jre11-slim

# Set the working directory in the container
WORKDIR /usr/local/tomcat/webapps

# Copy the WAR file into the container at the specified working directory
COPY ./target/*.war .

# Expose the default Tomcat port
EXPOSE 3001

# Specify the command to run on container start
CMD ["catalina.sh", "run"]
