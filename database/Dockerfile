FROM mysql:8.0
COPY my.cnf /etc/mysql/conf.d/my.cnf
COPY schema.sql /docker-entrypoint-initdb.d/01-schema.sql
COPY seed.sql /docker-entrypoint-initdb.d/02-seed.sql
COPY healthcheck.sh /healthcheck.sh
RUN chmod 0755 /healthcheck.sh
HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=10 CMD ["/healthcheck.sh"]
