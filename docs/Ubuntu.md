# Ubuntu Server 16.04

ubuntu-16.04.2-server-amd64
```
$ lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 16.04.2 LTS
Release:	16.04
Codename:	xenial
$ lsb_release -c
Codename:	xenial
```

## 服务器安装 OpenSSH 服务
OpenSSH是SSH的替代软件，而且是免费的
```
$ sudo apt-get install openssh-server
$ /etc/init.d/ssh status
```

## 生成密钥对，用户免密登录
（执行以下命令一路回车）
```
$ ssh-keygen -t rsa
```

## 更换国内源
参考：[http://wiki.ubuntu.org.cn/源列表](http://wiki.ubuntu.org.cn/源列表)

```
$ sudo cp /etc/apt/sources.list /etc/apt/sources.list_backup
$ sudo tee /etc/apt/sources.list <<-'EOF'
deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse
EOF
```
更新：
```
$ sudo apt-get update
```

## docker 安装

1. Set up the repository
```
$ sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

$ sudo apt-key fingerprint 0EBFCD88

$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

$ sudo apt-get update
```

2. Get Docker CE
```
$ sudo apt-get install -y docker-ce
```

```
$ docker -v
Docker version 18.03.1-ce, build 9ee9f40
```

## 补充常用的工具（vim）
```
$ sudo apt install -y vim
```


## ruby 安装(默认版本够用)
```
$ sudo apt-get install -y ruby
$ ruby -v
ruby 2.3.1p112 (2016-04-26) [x86_64-linux-gnu]
```
