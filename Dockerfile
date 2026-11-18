# ============================================================
# Multi-stage Docker build for Online Examination System
# Stage 1: Maven build    →  produces ROOT.war
# Stage 2: Tomcat runtime →  serves the application
# ============================================================

# --- Stage 1: Build ---
FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:resolve -B
COPY src ./src
RUN mvn clean package -DskipTests -B

# --- Stage 2: Runtime ---
FROM tomcat:10.1-jdk21-temurin-jammy

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy our WAR as ROOT (deploys at /)
COPY --from=builder /app/target/ROOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080 10000
CMD ["sh", "-c", "if [ -n \"$PORT\" ] && [ \"$PORT\" != \"8080\" ]; then sed -i 's/port=\"8080\"/port=\"'\"$PORT\"'\"/' /usr/local/tomcat/conf/server.xml; fi; exec catalina.sh run"]
