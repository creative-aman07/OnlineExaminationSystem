# ============================================================
# Multi-stage Docker build for Online Examination System
# Stage 1: Maven build    →  produces war & exploded webapp
# Stage 2: Tomcat runtime →  serves the application at root /
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

# Remove default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Render probes detected ports; disable Tomcat's unused plaintext shutdown socket.
RUN sed -i 's/<Server port="8005"/<Server port="-1"/' /usr/local/tomcat/conf/server.xml

# Deploy exploded webapp directly as ROOT (instant startup, zero runtime unpack delay)
COPY --from=builder /app/target/ROOT/ /usr/local/tomcat/webapps/ROOT/
# Also keep ROOT.war in webapps
COPY --from=builder /app/target/ROOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080 10000

# Dynamically adjust Tomcat HTTP port based on $PORT (Railway, Render, Cloud Run, etc.)
CMD ["sh", "-c", "APP_PORT=\"${PORT:-8080}\"; echo \"==> Starting Tomcat on port $APP_PORT ...\"; if [ \"$APP_PORT\" != \"8080\" ]; then sed -i 's/port=\"8080\"/port=\"'$APP_PORT'\"/g' /usr/local/tomcat/conf/server.xml; fi; exec catalina.sh run"]
