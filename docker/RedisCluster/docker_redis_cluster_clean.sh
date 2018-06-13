#!/usr/bin/env bash

docker rm -f redis_cluster_6381
rm -rf cluster_6381/*

docker rm -f redis_cluster_6382
rm -rf cluster_6382/*

docker rm -f redis_cluster_6383
rm -rf cluster_6383/*

docker rm -f redis_cluster_6384
rm -rf cluster_6384/*

docker rm -f redis_cluster_6385
rm -rf cluster_6385/*

docker rm -f redis_cluster_6386
rm -rf cluster_6386/*

rm -f redis-trib.rb
