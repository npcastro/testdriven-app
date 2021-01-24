FROM postgres:11.2-alpine

# We extend the official Postgres image by adding a SQL file to the "docker-entrypoint-initdb.d"
# directory in the container, which will execute on init.
ADD create.sql /docker-entrypoint-initdb.d
