## 集群部署

[![Build Status](https://travis-ci.org/zhanghe06/redis_cluster.svg?branch=master)](https://travis-ci.org/zhanghe06/redis_cluster)
[![Coverage Status](https://coveralls.io/repos/github/zhanghe06/redis_cluster/badge.svg?branch=master)](https://coveralls.io/github/zhanghe06/redis_cluster?branch=master)



- 哈希槽 总共16384个
- 单节点主失效, 对应从提升为主, 对应哈希槽分配过去
- 同一节点主从同时挂掉, 整个集群不可用, 应避免同一主从节点部署在一个物理节点
- docker 模拟需要`--net=host`模式, Mac不支持

https://github.com/Grokzen/redis-py-cluster

https://github.com/Grokzen/docker-redis-cluster


集群客户端
```
# pip install virtualenv
# virtualenv redis_cluster.env
# source redis_cluster.env/bin/activate
# pip install redis-py-cluster
```

集群命令
```
CLUSTER INFO 打印集群的信息
CLUSTER NODES 列出集群当前已知的所有节点（node），以及这些节点的相关信息。 
//节点
CLUSTER MEET <ip> <port> 将 ip 和 port 所指定的节点添加到集群当中，让它成为集群的一份子。
CLUSTER FORGET <node_id> 从集群中移除 node_id 指定的节点。
CLUSTER REPLICATE <node_id> 将当前节点设置为 node_id 指定的节点的从节点。
CLUSTER SAVECONFIG 将节点的配置文件保存到硬盘里面。
CLUSTER ADDSLOTS <slot> [slot ...] 将一个或多个槽（slot）指派（assign）给当前节点。
CLUSTER DELSLOTS <slot> [slot ...] 移除一个或多个槽对当前节点的指派。
CLUSTER FLUSHSLOTS 移除指派给当前节点的所有槽，让当前节点变成一个没有指派任何槽的节点。
CLUSTER SETSLOT <slot> NODE <node_id> 将槽 slot 指派给 node_id 指定的节点。
CLUSTER SETSLOT <slot> MIGRATING <node_id> 将本节点的槽 slot 迁移到 node_id 指定的节点中。
CLUSTER SETSLOT <slot> IMPORTING <node_id> 从 node_id 指定的节点中导入槽 slot 到本节点。
CLUSTER SETSLOT <slot> STABLE 取消对槽 slot 的导入（import）或者迁移（migrate）。 
//键
CLUSTER KEYSLOT <key> 计算键 key 应该被放置在哪个槽上。
CLUSTER COUNTKEYSINSLOT <slot> 返回槽 slot 目前包含的键值对数量。
CLUSTER GETKEYSINSLOT <slot> <count> 返回 count 个 slot 槽中的键。 
//新增
CLUSTER SLAVES node-id 返回一个master节点的slaves 列表
```
