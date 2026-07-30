# 🚀 Deployment Guide — Online Examination System

This guide covers **local setup**, **Docker deployment**, and **live hosting** (Railway.app, VPS, etc.).

---

## 📋 Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| Java JDK | 21+ | Compile & run the application |
| Maven | 3.9+ | Build tool |
| MySQL | 8.0+ | Primary database |
| Git | Any | Version control |
| Docker (optional) | 24+ | Containerized deployment |

---

## 1️⃣ Local Setup (Your Machine)

### Step 1: Install & Configure MySQL

If MySQL is installed but you don't know the root password, reset it:

```bash
# Windows (run as Administrator):
net stop MySQL80
mysqld --skip-grant-tables --skip-networking &
mysql -u root
```
```sql
-- Inside MySQL shell:
ALTER USER 'root'@'localhost' IDENTIFIED BY 'your_new_password';
FLUSH PRIVILEGES;
EXIT;
```
```bash
net start MySQL80
```

### Step 2: Create the Database

```bash
mysql -u root -p
```
```sql
CREATE DATABASE IF NOT EXISTS examdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
EXIT;
```

### Step 3: Configure Credentials

Create a `.env` file in the project root:

```env
DB_PASSWORD=your_mysql_root_password
```

Or edit `src/main/resources/db.properties`:
```properties
jdbc.url=jdbc:mysql://localhost:3306/examdb?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
jdbc.username=root
jdbc.password=your_password_here
```

### Step 4: Build & Run

```bash
mvn clean package cargo:run
```

Open **http://localhost:8080** in your browser.

> **Note:** If MySQL is unreachable, the app automatically falls back to H2 in-memory database. Your data won't persist between restarts in fallback mode.

---

## 2️⃣ Docker Deployment (Recommended for Production)

### One command to run everything:

```bash
docker-compose up --build -d
```

This starts:
- **MySQL 8.0** container (with persistent volume)
- **Tomcat 10** container (with your app)

Access at **http://localhost:8080**

### Stop:
```bash
docker-compose down
```

### View logs:
```bash
docker-compose logs -f app
```

---

## 3️⃣ Deploy to Railway.app (Easiest Live Hosting — FREE)

Railway gives you a **free MySQL database + auto-deploy from GitHub**.

### Step 1: Push to GitHub

```bash
cd OnlineExaminationSystem
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/OnlineExaminationSystem.git
git push -u origin main
```

### Step 2: Create Railway Project

1. Go to [railway.app](https://railway.app) and sign in with GitHub
2. Click **"New Project"** → **"Deploy from GitHub"**
3. Select your `OnlineExaminationSystem` repository
4. Railway auto-detects the `Dockerfile` and starts building

### Step 3: Add MySQL Database

1. In your Railway project, click **"+ New"** → **"Database"** → **"MySQL"**
2. Railway auto-injects these environment variables:
   - `MYSQLHOST`
   - `MYSQLPORT`
   - `MYSQL_DATABASE`
   - `MYSQLUSER`
   - `MYSQLPASSWORD`
3. The app's `DBConnection.java` already reads these — **zero config needed!**

### Step 4: Get Your Live URL

Railway assigns a URL like `https://your-app-name.up.railway.app`

✅ **Done! Your exam system is live on the internet.**

---

## 4️⃣ Deploy to a VPS (DigitalOcean / AWS EC2 / Linode)

### Step 1: Provision a Server

- **DigitalOcean**: Create a Droplet (Ubuntu 22.04, $6/month)
- **AWS EC2**: Launch an instance (t3.micro, free tier eligible)
- **Linode**: Create a Nanode ($5/month)

### Step 2: Install Dependencies

```bash
# SSH into your server
ssh root@YOUR_SERVER_IP

# Install Java 21
apt update && apt install -y openjdk-21-jdk

# Install MySQL 8
apt install -y mysql-server
mysql_secure_installation

# Create database
mysql -u root -p -e "CREATE DATABASE examdb CHARACTER SET utf8mb4;"

# Install Maven
apt install -y maven
```

### Step 3: Deploy the WAR

```bash
# Clone your repo
git clone https://github.com/YOUR_USERNAME/OnlineExaminationSystem.git
cd OnlineExaminationSystem

# Create .env with your MySQL credentials
echo 'DB_PASSWORD=your_mysql_password' > .env

# Build the WAR
mvn clean package -DskipTests

# Install Tomcat 10
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.28/bin/apache-tomcat-10.1.28.tar.gz
tar -xzf apache-tomcat-10.1.28.tar.gz -C /opt/
mv /opt/apache-tomcat-10.1.28 /opt/tomcat

# Deploy
cp target/ROOT.war /opt/tomcat/webapps/

# Set environment variables
export JDBC_URL="jdbc:mysql://localhost:3306/examdb?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC"
export DB_USER="root"
export DB_PASSWORD="your_mysql_password"

# Start Tomcat
/opt/tomcat/bin/startup.sh
```

### Step 4: Set Up a Domain (Optional)

1. Point your domain's A record to your server IP
2. Install Nginx as a reverse proxy:

```bash
apt install -y nginx

# /etc/nginx/sites-available/examportal
server {
    listen 80;
    server_name yourdomain.com;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

3. Enable HTTPS with Let's Encrypt:
```bash
apt install -y certbot python3-certbot-nginx
certbot --nginx -d yourdomain.com
```

---

## 🔐 Environment Variables Reference

| Variable | Description | Example |
|----------|-------------|---------|
| `JDBC_URL` | Full JDBC URL (highest priority) | `jdbc:mysql://host:3306/examdb?...` |
| `DB_USER` | Database username | `root` |
| `DB_PASSWORD` | Database password | `secret123` |
| `MYSQLHOST` | MySQL host (Railway) | `containers-us-west-1.railway.app` |
| `MYSQLPORT` | MySQL port (Railway) | `3306` |
| `MYSQL_DATABASE` | Database name (Railway) | `railway` |
| `MYSQLUSER` | MySQL user (Railway) | `root` |
| `MYSQLPASSWORD` | MySQL password (Railway) | `abc123` |

**Priority**: ENV vars > `.env` file > `db.properties` > H2 fallback

---

## 🧪 Demo Credentials

| Role | Email | Password |
|------|-------|----------|
| Admin | admin@exam.com | password123 |
| Student | student@exam.com | password123 |

---

## 📝 Application URLs

| Page | URL |
|------|-----|
| Homepage | `/` |
| Candidate Registration | `/candidate/register` |
| Available Tests | `/candidate/tests` |
| Take Exam | `/candidate/take?testId=1` |
| View Results | `/candidate/results` |
| Performance Analysis | `/candidate/analysis` |
| Question Bank | `/question-bank` |
| Login | `/login` |
| Admin Dashboard | `/faculty/dashboard.jsp` |
| Student Dashboard | `/student/dashboard.jsp` |
| Logout | `/logout` |
