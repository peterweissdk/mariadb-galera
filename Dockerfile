FROM ubuntu:24.04

# Prevent interactive prompts during package installation
ARG DEBIAN_FRONTEND=noninteractive

# Install needed packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common=0.99.49.1 \
    apt-transport-https=2.7.14build2 \
    apt-utils=2.7.14build2 \
    curl=8.5.0-2ubuntu10.6 \
    gnupg2=2.4.4-2ubuntu17 \
    rsync=3.2.7-1ubuntu1 \
    && rm -rf /var/lib/apt/lists/*

# Add MariaDB keyring
RUN mkdir -p /etc/apt/keyrings \
    && curl -o /etc/apt/keyrings/mariadb-keyring.pgp 'https://mariadb.org/mariadb_release_signing_key.pgp'

# Add MariaDB 11.4 LTS repository list
COPY conf/sources.list/mariadb.sources /etc/apt/sources.list.d/mariadb.sources

# Install MariaDB Server and Galera
RUN apt-get update && apt-get install -y --no-install-recommends \
    mariadb-server=1:11.4.4+maria~ubu2404 \
    mariadb-backup=1:11.4.4+maria~ubu2404 \
    galera-4=26.4.20-ubu2404 \
    mariadb-client=1:11.4.4+maria~ubu2404 \
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

# Add healthcheck script
COPY healthcheck.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/healthcheck.sh

# Configure healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5m --retries=3 CMD ["healthcheck.sh"]

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mysqld"]
