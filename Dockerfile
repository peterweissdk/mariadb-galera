FROM ubuntu:24.04

# Prevent interactive prompts during package installation
ARG DEBIAN_FRONTEND=noninteractive

# Add MariaDB repository
RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    gnupg2 \
    && curl -o /etc/apt/keyrings/mariadb-keyring.pgp 'https://mariadb.org/mariadb_release_signing_key.pgp' \
    && mkdir -p /etc/apt/keyrings \
    && chmod 644 /etc/apt/keyrings/mariadb-keyring.pgp

# Add MariaDB Repository
RUN echo "deb [signed-by=/etc/apt/keyrings/mariadb-keyring.pgp] https://mirrors.aliyun.com/mariadb/repo/11.4/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") main" > /etc/apt/sources.list.d/mariadb.list

# Install MariaDB Server and Galera
RUN apt-get install -y --no-install-recommends \
    mariadb-server-11.4 \
    mariadb-backup \
    galera-4 \
    mariadb-client \
    rsync \
    && rm -rf /var/lib/apt/lists/*

# Create directory for Galera configuration
RUN mkdir -p /etc/mysql/conf.d

# Create default galera configuration
RUN echo "[mysqld]\n\
wsrep_on=ON\n\
wsrep_provider=/usr/lib/galera/libgalera_smm.so\n\
wsrep_cluster_name=galera_cluster\n\
wsrep_cluster_address=gcomm://\n\
wsrep_node_name=node1\n\
wsrep_node_address=000.000.000.000\n\
wsrep_sst_method=rsync\n\
binlog_format=ROW\n\
default_storage_engine=InnoDB\n\
innodb_autoinc_lock_mode=2\n\
bind-address=0.0.0.0" > /etc/mysql/conf.d/galera.cnf

# Create volume mount points
VOLUME ["/var/lib/mysql", "/etc/mysql/conf.d"]

# Expose MariaDB and Galera ports
EXPOSE 3306 4444 4567 4568

# Set the entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mysqld"]
