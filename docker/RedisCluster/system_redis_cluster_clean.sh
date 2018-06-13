#!/usr/bin/env bash

ps -ef | grep redis-server | awk '{print $2}' | xargs kill

rm -rf cluster_6381/*
rm -rf cluster_6382/*
rm -rf cluster_6383/*
rm -rf cluster_6384/*
rm -rf cluster_6385/*
rm -rf cluster_6386/*

rm -f /usr/local/bin/redis-trib.rb
