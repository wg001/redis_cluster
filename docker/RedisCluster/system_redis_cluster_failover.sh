#!/usr/bin/env bash


CLUSTER_01_IP='10.21.2.231'
CLUSTER_02_IP='10.21.2.231'

CLUSTER_01_PORT=6391
CLUSTER_02_PORT=6392


CLUSTER_IP='10.21.2.231'
CLUSTER_PORT=6381


SLOTS_OLD=3
SLOTS_NEW=4

TRANS_SLOTS_NUM=$[(16384/${SLOTS_OLD}-16384/${SLOTS_NEW})/(SLOTS_NEW-SLOTS_OLD)]

ps -ef | grep "redis-server 0.0.0.0:${CLUSTER_01_PORT}" | awk '{print $2}' | xargs kill
ps -ef | grep "redis-server 0.0.0.0:${CLUSTER_02_PORT}" | awk '{print $2}' | xargs kill

rm -rf cluster_${CLUSTER_01_PORT}/*
rm -rf cluster_${CLUSTER_02_PORT}/*


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

ROOT_DIR=${PWD}


cd ${ROOT_DIR}/cluster_${CLUSTER_01_PORT}
redis-server redis.conf

cd ${ROOT_DIR}/cluster_${CLUSTER_02_PORT}
redis-server redis.conf


# Check node status
ps -ef | grep redis


wget https://raw.githubusercontent.com/antirez/redis/unstable/src/redis-trib.rb


gem install redis

# Add Node
ruby redis-trib.rb add-node ${CLUSTER_01_IP}:${CLUSTER_01_PORT} ${CLUSTER_IP}:${CLUSTER_PORT}
ruby redis-trib.rb add-node --slave ${CLUSTER_02_IP}:${CLUSTER_02_PORT} ${CLUSTER_IP}:${CLUSTER_PORT}


ruby redis-trib.rb check ${CLUSTER_01_IP}:${CLUSTER_01_PORT}
ruby redis-trib.rb info ${CLUSTER_01_IP}:${CLUSTER_01_PORT}


# Reshard todo
#ruby redis-trib.rb reshard --from 4c9bd82f --to 97ea826e --slots ${TRANS_SLOTS_NUM} --yes ${CLUSTER_IP}:${CLUSTER_PORT}
#ruby redis-trib.rb reshard --from ef93c5e2 --to 97ea826e --slots ${TRANS_SLOTS_NUM} --yes ${CLUSTER_IP}:${CLUSTER_PORT}
#ruby redis-trib.rb reshard --from 7b450c6a --to 97ea826e --slots ${TRANS_SLOTS_NUM} --yes ${CLUSTER_IP}:${CLUSTER_PORT}


ruby redis-trib.rb check ${CLUSTER_01_IP}:${CLUSTER_01_PORT}
ruby redis-trib.rb info ${CLUSTER_01_IP}:${CLUSTER_01_PORT}
