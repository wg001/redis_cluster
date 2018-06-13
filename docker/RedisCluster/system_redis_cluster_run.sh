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
daemonize yes
EOF

cat << EOF > cluster_${CLUSTER_02_PORT}/redis.conf
bind 0.0.0.0
port ${CLUSTER_02_PORT}
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
daemonize yes
EOF

cat << EOF > cluster_${CLUSTER_03_PORT}/redis.conf
bind 0.0.0.0
port ${CLUSTER_03_PORT}
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
daemonize yes
EOF

cat << EOF > cluster_${CLUSTER_04_PORT}/redis.conf
bind 0.0.0.0
port ${CLUSTER_04_PORT}
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
daemonize yes
EOF

cat << EOF > cluster_${CLUSTER_05_PORT}/redis.conf
bind 0.0.0.0
port ${CLUSTER_05_PORT}
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
daemonize yes
EOF

cat << EOF > cluster_${CLUSTER_06_PORT}/redis.conf
bind 0.0.0.0
port ${CLUSTER_06_PORT}
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
daemonize yes
EOF

ROOT_DIR=${PWD}


cd ${ROOT_DIR}/cluster_${CLUSTER_01_PORT}
redis-server redis.conf

cd ${ROOT_DIR}/cluster_${CLUSTER_02_PORT}
redis-server redis.conf

cd ${ROOT_DIR}/cluster_${CLUSTER_03_PORT}
redis-server redis.conf

cd ${ROOT_DIR}/cluster_${CLUSTER_04_PORT}
redis-server redis.conf

cd ${ROOT_DIR}/cluster_${CLUSTER_05_PORT}
redis-server redis.conf

cd ${ROOT_DIR}/cluster_${CLUSTER_06_PORT}
redis-server redis.conf


# Check node status
ps -ef | grep redis


wget https://raw.githubusercontent.com/antirez/redis/unstable/src/redis-trib.rb

mv redis-trib.rb /usr/local/bin/redis-trib.rb

chmod +x /usr/local/bin/redis-trib.rb

gem install redis

redis-trib.rb create --replicas 1 \
    ${CLUSTER_01_IP}:${CLUSTER_01_PORT} \
    ${CLUSTER_02_IP}:${CLUSTER_02_PORT} \
    ${CLUSTER_03_IP}:${CLUSTER_03_PORT} \
    ${CLUSTER_04_IP}:${CLUSTER_04_PORT} \
    ${CLUSTER_05_IP}:${CLUSTER_05_PORT} \
    ${CLUSTER_06_IP}:${CLUSTER_06_PORT}


redis-trib.rb check ${CLUSTER_01_IP}:${CLUSTER_01_PORT}

redis-trib.rb info ${CLUSTER_01_IP}:${CLUSTER_01_PORT}
