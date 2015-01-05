FROM neowaylabs/baseimage:latest

MAINTAINER Rodrigo Zanato Tripodi <rodrigo.tripodi@neoway.com.br>

EXPOSE 5432

ENV POSTGRES_PASSWD postgis

RUN curl -s https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list && \
    apt-get update -qqy && \
    apt-get install -qqy postgresql-9.3 postgresql-contrib-9.3 postgresql-9.3-postgis-2.1 postgis && \
    echo "host    all             all             0.0.0.0/0               md5" >> /etc/postgresql/9.3/main/pg_hba.conf && \
    echo "listen_addresses = '*'" >> /etc/postgresql/9.3/main/postgresql.conf && \
    echo "port = 5432" >> /etc/postgresql/9.3/main/postgresql.conf && \
    service postgresql start 9.3 && \
    /bin/su postgres -c "createuser -d -s -r -l docker" && \
    /bin/su postgres -c "psql -c \"ALTER USER docker WITH ENCRYPTED PASSWORD '$POSTGRES_PASSWD'\" postgres" && \
    /bin/su postgres -c "PGPASSWORD=$POSTGRES_PASSWD psql -U docker -h localhost -c \"CREATE DATABASE docker\" postgres" && \
    /bin/su postgres -c "PGPASSWORD=$POSTGRES_PASSWD psql -U docker -h localhost -c \"CREATE EXTENSION POSTGIS\" docker" && \
    service postgresql stop

ADD 01_postgres.sh /etc/my_init.d/01_postgres.sh
RUN chmod +x /etc/my_init.d/01_postgres.sh

CMD ["/sbin/my_init"]

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
