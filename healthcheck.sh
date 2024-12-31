#!/bin/bash
set -eo pipefail

# Wait for MySQL to be ready
for i in {1..30}; do
    if mysqladmin ping -h localhost --silent; then
        break
    fi
    if [ "$i" = 30 ]; then
        echo "MySQL is not responding to ping"
        exit 1
    fi
    sleep 1
done

# Check Galera provider status
WSREP_STATUS=$(mysql -N -e "SHOW STATUS LIKE 'wsrep_ready';" | awk '{print $2}')
if [ "$WSREP_STATUS" != "ON" ]; then
    echo "Galera provider is not ready (wsrep_ready: $WSREP_STATUS)"
    exit 1
fi

# Check cluster size
CLUSTER_SIZE=$(mysql -N -e "SHOW STATUS LIKE 'wsrep_cluster_size';" | awk '{print $2}')
if [ "$CLUSTER_SIZE" -lt 1 ]; then
    echo "No nodes in Galera cluster (cluster size: $CLUSTER_SIZE)"
    exit 1
fi

# Check node state
NODE_STATE=$(mysql -N -e "SHOW STATUS LIKE 'wsrep_local_state_comment';" | awk '{print $2}')
if [ "$NODE_STATE" != "Synced" ]; then
    echo "Node is not synced (state: $NODE_STATE)"
    exit 1
fi

echo "Healthcheck passed - Galera node is healthy and synced"
exit 0
