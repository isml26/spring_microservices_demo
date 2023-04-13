# Stage 1 - Build the application
FROM eclipse-temurin:17-jre AS builder
WORKDIR extracted
ADD target/*.jar app.jar
# Extract 4 layers from spring-boot jar store them inside the extracted folder
RUN java -Djarmode=layertools -jar app.jar extract

FROM eclipse-temurin:17-jre
WORKDIR application
COPY --from=builder extracted/dependencies/ ./
COPY --from=builder extracted/spring-boot-loader/ ./
COPY --from=builder extracted/snapshot-dependencies/ ./
COPY --from=builder extracted/application/ ./

EXPOSE 8080
CMD ["java", "org.springframework.boot.loader.JarLauncher"]
