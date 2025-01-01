# 💾 MariaDB Galera Container

## -----NOT PRODUCTION READY-----

[![Static Badge](https://img.shields.io/badge/Docker-Container-white?style=flat&logo=docker&logoColor=white&logoSize=auto&labelColor=black)](https://docker.com/)
[![Static Badge](https://img.shields.io/badge/Ubuntu-24.04-white?style=flat&logo=ubuntu&logoColor=white&logoSize=auto&labelColor=black)](https://www.ubuntu.com/)
[![Static Badge](https://img.shields.io/badge/MariaDB-V11.4-white?style=flat&logo=mariadb&logoColor=white&logoSize=auto&labelColor=black)](https://www.mariadb.org/)
[![Static Badge](https://img.shields.io/badge/GPL-V3-white?style=flat&logo=gnu&logoColor=white&logoSize=auto&labelColor=black)](https://www.gnu.org/licenses/gpl-3.0.en.html/)

A Docker container for running MariaDB Galera Cluster on Ubuntu 24.04 base image, providing a highly available and scalable database solution.

## ✨ Features

- Based on Ubuntu 24.04 (Noble)
- MariaDB 11.4 LTS with Galera Cluster
- Automated health monitoring
- Optimized for container environments
- Configurable through environment variables
- Built-in backup support with mariadb-backup

## 🚀 Quick Start

```bash
# Pull the image
docker pull peterweissdk/mariadb-galera:latest

# Start the first node
docker run -d \
  --name galera-node1 \
  -e MYSQL_ROOT_PASSWORD=your_password \
  -e GALERA_CLUSTER_NAME=my_cluster \
  -e GALERA_NODE_ADDRESS=node1_ip \
  peterweissdk/mariadb-galera:latest

# Join additional nodes
docker run -d \
  --name galera-node2 \
  -e MYSQL_ROOT_PASSWORD=your_password \
  -e GALERA_CLUSTER_NAME=my_cluster \
  -e GALERA_NODE_ADDRESS=node2_ip \
  -e GALERA_CLUSTER_ADDRESS=gcomm://node1_ip \
  peterweissdk/mariadb-galera:latest
```

## 🔧 Configuration

### Environment Variables

- `MYSQL_ROOT_PASSWORD`: Root password for MariaDB
- `GALERA_CLUSTER_NAME`: Name of the Galera cluster
- `GALERA_NODE_ADDRESS`: IP address of this node
- `GALERA_CLUSTER_ADDRESS`: Cluster connection address (gcomm://)
- `MYSQL_DATABASE`: Create this database on startup
- `MYSQL_USER`: Create this user on startup
- `MYSQL_PASSWORD`: Password for MYSQL_USER

### Ports

- 3306: MariaDB
- 4444: SST (State Snapshot Transfer)
- 4567: Galera Cluster
- 4568: IST (Incremental State Transfer)

## 🏗️ Building from Source

```bash
# Clone the repository
git clone https://github.com/peterweissdk/mariadb-galera.git

# Build the image
cd mariadb-galera
docker build -t mariadb-galera .
```

## 📝 Directory Structure

```bash
.
├── conf
│   ├── galera
│   │   └── galera.cnf
│   └── sources.list
│       └── mariadb.sources
├── docker-entrypoint.sh
├── Dockerfile
├── healthcheck.sh
├── LICENSE
└── README.md
```

## 🔍 Health Check

The container includes a comprehensive health monitoring system that checks:

- MariaDB service availability
- Galera provider status (wsrep_ready)
- Cluster size and connectivity
- Node synchronization state

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 🆘 Support

If you encounter any issues or need support, please file an issue on the GitHub repository.

## 📄 License

This project is licensed under the GNU GENERAL PUBLIC LICENSE v3.0 - see the [LICENSE](LICENSE) file for details.
