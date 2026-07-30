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

# The app reads these environment variables for database config:
#   JDBC_URL       - full JDBC URL (highest priority)
#   DB_USER        - database username
#   DB_PASSWORD    - database password
# OR Railway-style:
#   MYSQLHOST, MYSQLPORT, MYSQL_DATABASE, MYSQLUSER, MYSQLPASSWORD

EXPOSE 8080
CMD ["catalina.sh", "run"]