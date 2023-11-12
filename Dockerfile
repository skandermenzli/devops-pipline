# Use a base image with Java and Maven pre-installed
FROM maven:3.9.2-openjdk-8 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the project's POM file and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the rest of the application source code
COPY src ./src

# Build the application
RUN mvn package

# Use a smaller base image for the final image
FROM openjdk:8-jre-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file built in the previous stage to the final image
COPY --from=build /app/target/MyMavenProject-1.0-SNAPSHOT.jar app.jar

# Define the command to run your application
CMD ["java", "-jar", "app.jar"]
