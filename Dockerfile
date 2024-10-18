# FROM adoptopenjdk/openjdk11
    
# EXPOSE 8080
 
# ENV APP_HOME /usr/src/app

# COPY target/*.jar $APP_HOME/app.jar

# WORKDIR $APP_HOME

# CMD ["java", "-jar", "app.jar"]

# Stage 1: Build the application
FROM maven:3.8.5-openjdk-11 AS build

# Set the working directory
WORKDIR /usr/src/app

# Copy the pom.xml and the source code
COPY pom.xml ./
COPY src ./src

# Package the application
RUN mvn clean package -DskipTests

# Stage 2: Create the final image
FROM eclipse-temurin:11-jre

# Set the environment variable for the application home
ENV APP_HOME /usr/src/app

# Expose the application's port
EXPOSE 8080

# Copy the built JAR file from the build stage
COPY --from=build /usr/src/app/target/*.jar $APP_HOME/app.jar

# Set the working directory
WORKDIR $APP_HOME

# Command to run the application
CMD ["java", "-jar", "app.jar"]


