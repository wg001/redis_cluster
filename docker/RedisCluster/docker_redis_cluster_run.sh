#!/usr/bin/env bash

CLUSTER_01_IP='0.0.0.0'
CLUSTER_02_IP='0.0.0.0'
CLUSTER_03_IP='0.0.0.0'
CLUSTER_04_IP='0.0.0.0'
CLUSTER_05_IP='0.0.0.0'
CLUSTER_06_IP='0.0.0.0'

CLUSTER_01_PORT=6381
CLUSTER_02_PORT=6382
CLUSTER_03_PORT=6383
CLUSTER_04_PORT=6384
CLUSTER_05_PORT=6385
CLUSTER_06_PORT=6386


[ -d ${PWD}/cluster_${CLUSTER_01_PORT} ] || mkdir -p ${PWD}/cluster_${CLUSTER_01_PORT}
[ -d ${PWD}/cluster_${CLUSTER_02_PORT} ] || mkdir -p ${PWD}/cluster_${CLUSTER_02_PORT}
[ -d ${PWD}/cluster_${CLUSTER_03_PORT} ] || mkdir -p ${PWD}/cluster_${CLUSTER_03_PORT}
[ -d ${PWD}/cluster_${CLUSTER_04_PORT} ] || mkdir -p ${PWD}/cluster_${CLUSTER_04_PORT}
[ -d ${PWD}/cluster_${CLUSTER_05_PORT} ] || mkdir -p ${PWD}/cluster_${CLUSTER_05_PORT}
[ -d ${PWD}/cluster_${CLUSTER_06_PORT} ] || mkdir -p ${PWD}/cluster_${CLUSTER_06_PORT}


cat << EOF > cluster_${CLUSTER_01_PORT}/redis.conf
bind 0.0.0.0
port ${CLUSTER_01_PORT}
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
EOF

cat << EOF > cluster_${CLUSTER_02_PORT}/redis.conf
bind 0.0.0.0
port ${CLUSTER_02_PORT}
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
EOF

cat << EOF > cluster_${CLUSTER_03_PORT}/redis.conf
bind 0.0.0.0
port ${CLUSTER_03_PORT}
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
EOF

cat << EOF > cluster_${CLUSTER_04_PORT}/redis.conf
bind 0.0.0.0
port ${CLUSTER_04_PORT}
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
EOF

cat << EOF > cluster_${CLUSTER_05_PORT}/redis.conf
bind 0.0.0.0
port ${CLUSTER_05_PORT}
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
EOF

cat << EOF > cluster_${CLUSTER_06_PORT}/redis.conf
bind 0.0.0.0
port ${CLUSTER_06_PORT}
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
EOF


# Node 1
docker run \
    -h redis_cluster_${CLUSTER_01_PORT} \
    --name redis_cluster_${CLUSTER_01_PORT} \
    --network=host \
    -v ${PWD}/cluster_${CLUSTER_01_PORT}/:/data/ \
    -d \
    redis:3.2.8 \
    redis-server redis.conf

# Node 3
docker run \
    -h redis_cluster_${CLUSTER_03_PORT} \
    --name redis_cluster_${CLUSTER_03_PORT} \
    --network=host \
    -v ${PWD}/cluster_${CLUSTER_03_PORT}/:/data/ \
    -d \
    redis:3.2.8 \
    redis-server redis.conf

# Node 5
docker run \
    -h redis_cluster_${CLUSTER_05_PORT} \
    --name redis_cluster_${CLUSTER_05_PORT} \
    --network=host \
    -v ${PWD}/cluster_${CLUSTER_05_PORT}/:/data/ \
    -d \
    redis:3.2.8 \
    redis-server redis.conf

# Node 2
docker run \
    -h redis_cluster_${CLUSTER_02_PORT} \
    --name redis_cluster_${CLUSTER_02_PORT} \
    --network=host \
    -v ${PWD}/cluster_${CLUSTER_02_PORT}/:/data/ \
    -d \
    redis:3.2.8 \
    redis-server redis.conf

# Node 4
docker run \
    -h redis_cluster_${CLUSTER_04_PORT} \
    --name redis_cluster_${CLUSTER_04_PORT} \
    --network=host \
    -v ${PWD}/cluster_${CLUSTER_04_PORT}/:/data/ \
    -d \
    redis:3.2.8 \
    redis-server redis.conf

# Node 6
docker run \
    -h redis_cluster_${CLUSTER_06_PORT} \
    --name redis_cluster_${CLUSTER_06_PORT} \
    --network=host \
    -v ${PWD}/cluster_${CLUSTER_06_PORT}/:/data/ \
    -d \
    redis:3.2.8 \
    redis-server redis.conf

# Check node status
docker ps | grep redis_cluster_


wget https://raw.githubusercontent.com/antirez/redis/unstable/src/redis-trib.rb

mv redis-trib.rb /usr/local/bin/redis-trib.rb

chmod +x /usr/local/bin/redis-trib.rb

gem install redis

# Create Cluster (Type 'yes')
redis-trib.rb create --replicas 1 \
    ${CLUSTER_01_IP}:${CLUSTER_01_PORT} \
    ${CLUSTER_02_IP}:${CLUSTER_02_PORT} \
    ${CLUSTER_03_IP}:${CLUSTER_03_PORT} \
    ${CLUSTER_04_IP}:${CLUSTER_04_PORT} \
    ${CLUSTER_05_IP}:${CLUSTER_05_PORT} \
    ${CLUSTER_06_IP}:${CLUSTER_06_PORT}

# Sequence: Node-01 master、Node-02 master、Node-03 master、Node-01 slave、Node-02 slave、Node-03 slave

redis-trib.rb check ${CLUSTER_01_IP}:${CLUSTER_01_PORT}

redis-trib.rb info ${CLUSTER_01_IP}:${CLUSTER_01_PORT}
