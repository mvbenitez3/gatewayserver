FROM eclipse-temurin:17
WORKDIR /usr/src/myapp
COPY target/*.jar ./gatewayserver.jar
ENTRYPOINT ["java", "-jar", "gatewayserver.jar"]