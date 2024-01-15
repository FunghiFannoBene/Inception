FROM debian:bullseye

EXPOSE 3306 

RUN apt-get update -y && \
    apt-get install -y mariadb-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/mysqld/ && chmod 777 /var/run/mysqld/

RUN sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

CMD ["mysqld", "--socket=/var/run/mysqld/mysqld.sock"]
