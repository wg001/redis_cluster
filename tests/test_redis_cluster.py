#!/usr/bin/env python
# encoding: utf-8

"""
@author: zhanghe
@software: PyCharm
@file: test_redis_cluster.py
@time: 2018-06-11 17:15
"""


from rediscluster import StrictRedisCluster

redis_nodes = [
    {'host': '127.0.0.1', 'port': '6381'},
    {'host': '127.0.0.1', 'port': '6382'},
    {'host': '127.0.0.1', 'port': '6383'},
    {'host': '127.0.0.1', 'port': '6384'},
    {'host': '127.0.0.1', 'port': '6385'},
    {'host': '127.0.0.1', 'port': '6386'},
]

rc = StrictRedisCluster(startup_nodes=redis_nodes, decode_responses=True)
rc.set("foo", "bar")
print(rc.get("foo"))


if __name__ == '__main__':
    pass

"""
➜  ~ redis-cli -p 6386
127.0.0.1:6386> KEYS *
1) "foo"
127.0.0.1:6386> get foo
(error) MOVED 12182 10.21.2.231:6383

➜  ~ redis-cli -c -p 6386
127.0.0.1:6386> KEYS *
1) "foo"
127.0.0.1:6386> get foo
-> Redirected to slot [12182] located at 10.21.2.231:6383
"bar"

127.0.0.1:6383> CLUSTER INFO
cluster_state:ok
cluster_slots_assigned:16384
cluster_slots_ok:16384
cluster_slots_pfail:0
cluster_slots_fail:0
cluster_known_nodes:6
cluster_size:3
cluster_current_epoch:6
cluster_my_epoch:3
cluster_stats_messages_sent:12140
cluster_stats_messages_received:12140

127.0.0.1:6386> CLUSTER NODES
13baa9fc9dc8d8aa03f45b9ed6d6e9908bf337e3 10.21.2.231:6383 master - 0 1528786527286 3 connected 10923-16383
fc073f387ba78c89f5ab5e679f079a86b60ae23e 10.21.2.231:6386 myself,slave 13baa9fc9dc8d8aa03f45b9ed6d6e9908bf337e3 0 0 6 connected
fde3cac71205131d9887366e6564eea2c3e48627 10.21.2.231:6381 master - 0 1528786525775 1 connected 0-5460
11284959e3da32a63ae8033b2e1eee48f06848e7 10.21.2.231:6385 slave 4d6bf6379f7e118f56c4326dd68a27c4cc4dee7c 0 1528786526277 5 connected
4e1e80bb7c7a10d733b511eee67a34483d1f374c 10.21.2.231:6384 slave fde3cac71205131d9887366e6564eea2c3e48627 0 1528786525270 4 connected
4d6bf6379f7e118f56c4326dd68a27c4cc4dee7c 10.21.2.231:6382 master - 0 1528786527286 2 connected 5461-10922

"""
