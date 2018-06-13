#!/usr/bin/env bash

docker run \
    -h haproxy \
    --name haproxy \
    -v ${PWD}/conf:/usr/local/etc/haproxy:ro \
    -p 8080:80 \
    -d \
    haproxy:1.8
