# Online Examination & Assessment Management System

A Java 21, JSP, Jakarta Servlet, JDBC/HikariCP, and MySQL 8 examination application.

## Architecture

Browser -> Tomcat 10 WAR -> Jakarta Servlets/JSP -> HikariCP -> MySQL 8 private service

The application is deployed from `Dockerfile` and the database from `database/Dockerfile`. The WAR is deployed as `ROOT.war`.

The UI uses a shared light theme with navy primary (`#172554`), indigo actions (`#4F46E5`), blue accents (`#3B82F6`), and slate text. The common design tokens and responsive components live in `src/main/webapp/css/app-theme.css`.

## Student workflow

1. Register with a name, roll number, email, and password, or sign in.
2. Browse currently scheduled exams.
3. Start an exam; the attempt deadline is enforced server-side.
4. Submit answers to receive the evaluated result.
5. View previous results and performance analysis from the student dashboard.

Administrators sign in to reach the faculty dashboard and question bank. Public users may browse tests, but need a student account to start one.

## Local development

```bash
docker compose up --build
```

Application: `http://localhost:8080`
MySQL: `localhost:3306` (development only)

Direct Maven/Tomcat development:

```bash
mvn clean package
# Deploy target/ROOT.war to a Tomcat 10 installation
```

## Database

- Full schema: `database/schema.sql`
- Role data: `database/seed.sql`
- Application repeatable schema: `src/main/resources/schema.sql`
- Initialization runs only at application startup and uses idempotent `CREATE TABLE IF NOT EXISTS` statements. It does not recreate or delete production data.

To initialize a fresh local database manually:

```bash
docker compose up -d db
docker compose exec -T db mysql -uroot -pexamdb_root_pass examdb < database/schema.sql
docker compose exec -T db mysql -uroot -pexamdb_root_pass examdb < database/seed.sql
```

## Environment variables

Copy `.env.example` to `.env` for local use.

| Variable | Purpose |
|---|---|
| DB_HOST | Private MySQL hostname |
| DB_PORT | MySQL port, normally 3306 |
| DB_NAME | Database name |
| DB_USERNAME | Application database user |
| DB_PASSWORD | Application database password |
| DB_DRIVER | JDBC driver |
| DB_SSL | Enable/disable JDBC TLS; verify private network TLS support |
| DB_TIMEZONE | JDBC timezone |
| DB_POOL_MIN/MAX | Hikari pool sizes |
| DB_CONNECTION_TIMEOUT | Hikari connection timeout in milliseconds |
| DB_QUERY_TIMEOUT | Query timeout in seconds |
| PORT | Render/Tomcat HTTP port |

Never commit `.env` or real credentials.

## Render deployment

1. Push the repository to GitHub.
2. In Render, create a Blueprint from `render.yaml`.
3. Render creates `examportal-mysql` and `examportal-app`.
4. Set generated MySQL secrets and verify the private internal hostname.
5. Deploy the database private service first and confirm `/healthcheck.sh` succeeds.
6. Deploy the web service and verify `https://<service>.onrender.com/health`.

When `DB_HOST` and `DB_NAME` are set, those Render settings take precedence over any stale `JDBC_URL` or generic provider URL. Otherwise, `JDBC_URL` is used as the explicit connection setting.

Persistent disk: mount a billable Render disk at `/var/lib/mysql`. Do not expose port 3306 publicly. Private services are not reachable from the public internet.

The internal hostname assigned by Render may differ from the service name. If it does, set `DB_HOST` to the actual Render internal hostname and redeploy.

## Tests

```bash
mvn clean test
mvn clean package
```

The packaged artifact is `target/ROOT.war`.

## Backup and recovery

Create an external backup:

```bash
mysqldump -h <MYSQL_HOST> -P 3306 -u <MYSQL_USER> -p --single-transaction --routines --triggers examdb > examdb.sql
```

Restore into a fresh database:

```bash
mysql -h <MYSQL_HOST> -P 3306 -u <MYSQL_USER> -p examdb < examdb.sql
```

Verify restore:

```bash
mysql -h <MYSQL_HOST> -P 3306 -u <MYSQL_USER> -p -e "SELECT COUNT(*) FROM examdb.results;"
```

Store backups outside the MySQL container or disk and verify a restore periodically.

## Demo accounts & Demo Exams

The application automatically seeds ready-to-use demo accounts and examinations on startup across any platform:

| Role | Email | Password | Access / Notes |
|---|---|---|---|
| **Admin** | `admin@exam.com` | `password123` | Faculty Dashboard & Question Bank Management |
| **Student** | `student@exam.com` | `password123` | Student Dashboard, Assessment catalog, Results |

### Pre-loaded Assessments
1. **Java Full Stack & Core Programming** (20 mins, 6 MCQs covering OOP, JVM, Collections, Types)
2. **Web Technologies & Database Systems** (15 mins, 5 MCQs covering HTTP, Servlets, SQL, ACID)
3. **General Aptitude & Logical Reasoning** (15 mins, 5 MCQs covering quantitative and logical reasoning)

## Security

- BCrypt password hashing
- Secure, cookie-based sessions
- CSRF tokens on POST forms
- CSP and security headers
- PreparedStatements
- Server-side role checks and examination deadlines
- Duplicate submission and result ownership checks
