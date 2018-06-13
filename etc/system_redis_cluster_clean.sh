#!/usr/bin/env bash

ps -ef | grep redis-server | awk '{print $2}' | xargs kill

echo 'yes' | rm -rf cluster_*

rm -f redis-trib.rb
