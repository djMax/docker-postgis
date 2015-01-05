#!/bin/bash
set -e

DATADIR="/var/lib/postgresql/9.3/main"
CONF="/etc/postgresql/9.3/main/postgresql.conf"
POSTGRES="/usr/lib/postgresql/9.3/bin/postgres"

if [ -n "${POSTGRES_PASSWD}" ]; then
	su postgres sh -c "$POSTGRES --single -jE postgres -D $DATADIR -c config_file=$CONF" <<-EOSQL
		ALTER USER docker WITH ENCRYPTED PASSWORD '$POSTGRES_PASSWD'
	EOSQL
fi

su postgres sh -c "$POSTGRES -D $DATADIR -c config_file=$CONF"
