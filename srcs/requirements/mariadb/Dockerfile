FROM debian:bullseye

RUN apt-get update -y && \
    apt-get install -y mariadb-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/mysqld/ && chmod 777 /var/run/mysqld/

RUN chown -R mysql:mysql /var/lib/mysql
RUN chmod -R 755 /var/lib/mysql

COPY ./tools/CPP_MARIADB .
COPY ./tools/MYSQL_START .

RUN chmod +x ./CPP_MARIADB
RUN chmod +x ./MYSQL_START

CMD ["./MYSQL_START"]
