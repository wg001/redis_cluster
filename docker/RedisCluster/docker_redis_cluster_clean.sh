#!/usr/bin/env bash

docker rm -f redis_cluster_6381

docker rm -f redis_cluster_6382

docker rm -f redis_cluster_6383

docker rm -f redis_cluster_6384

docker rm -f redis_cluster_6385

docker rm -f redis_cluster_6386

echo 'yes' | rm -rf cluster_*
rm -f redis-trib.rb
