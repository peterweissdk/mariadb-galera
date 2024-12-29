FROM ubuntu:24.04

# Prevent interactive prompts during package installation
ARG DEBIAN_FRONTEND=noninteractive

# Add MariaDB repository
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common=0.99.48 \
    apt-transport-https=2.7.14build2 \
    curl=7.68.0-1ubuntu2 \
    gnupg2=2.4.4-2ubuntu17 \
    rsync=3.2.7-1ubuntu1 \
    && rm -rf /var/lib/apt/lists/*

# Add MariaDB keyring
RUN mkdir -p /etc/apt/keyrings \
    && curl -o /etc/apt/keyrings/mariadb-keyring.pgp 'https://mariadb.org/mariadb_release_signing_key.pgp'

# Add MariaDB 11.4 repository list
COPY conf/sources.list/mariadb.sources /etc/apt/sources.list.d/mariadb.sources

# Install MariaDB Server and Galera
RUN apt-get update && apt-get install -y --no-install-recommends \
    mariadb-server \
    mariadb-backup \
    galera-4 \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Create directory for Galera configuration
RUN mkdir -p /etc/mysql/conf.d

# Copy default Galera configuration
COPY conf/galera/galera.cnf /etc/mysql/conf.d

# Create volume mount points
VOLUME ["/var/lib/mysql", "/etc/mysql/conf.d"]

# Expose MariaDB and Galera ports
EXPOSE 3306 4444 4567 4568

# Set the entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mysqld"]
