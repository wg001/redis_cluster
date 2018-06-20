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
$ sudo tee /etc/apt/sources.list << EOF
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

https://docs.docker.com/install/linux/docker-ce/ubuntu

Uninstall old versions (Option)
```
$ sudo apt-get remove docker docker-engine docker.io
```

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

## 安装 pip
```
$ sudo apt-get install -y python-pip
```

修改 pip 源配置
```
$ mkdir ~/.pip
$ tee ~/.pip/pip.conf << EOF
[global]
index-url = http://mirrors.aliyun.com/pypi/simple/

[install]
trusted-host=mirrors.aliyun.com
EOF
```

升级 pip
```
$ pip install -U pip
$ pip -V
```

## pip 排错

locale.Error: unsupported locale setting
```
$ export LC_ALL=C
```

ImportError: cannot import name main
```
$ pip2 -V
```

## ShadowSocks 客户端配置

```
$ sudo pip2 install git+https://github.com/shadowsocks/shadowsocks.git@master
$ sudo tee shawdowsocks.json << EOF
{
    "server": "149.28.57.192",
    "server_port": 8282,
    "local_port": 1080,
    "password": "******",
    "timeout": 600,
    "method": "aes-256-cfb"
}
EOF
$ sudo sslocal -c shawdowsocks.json --user nobody -d start
```

## Privoxy (socks转http)

```
$ sudo apt-get install -y privoxy
$ sudo sed -i "s/listen-address  localhost:8118/listen-address  127.0.0.1:8118/g" /etc/privoxy/config
$ sudo sh -c 'echo "forward-socks5t   /               127.0.0.1:1080 ." >> /etc/privoxy/config'
$ sudo systemctl restart privoxy
```
说明: ipv6 转为 ipv4, 即将 listen-address `localhost`换为`127.0.0.1`

测试代理
```
$ curl ip.cn
当前 IP：180.168.17.114 来自：上海市 电信
$ curl -x 127.0.0.1:8118 ip.cn
当前 IP：149.28.57.192 来自：美国 Choopa
```

## 设置 git 代理
```
git config --global http.proxy http://127.0.0.1:8118
git config --global https.proxy http://127.0.0.1:8118
```
或者修改 .gitconfig

临时使用
```
git -c https.proxy=http://127.0.0.1:8118 clone --depth=1 https://github.com/xxx/xxx
```

取消 git 代理配置
```
git config --global --unset http.proxy
git config --global --unset https.proxy
```

## 设置 curl 代理
```
$ export http_proxy='http://127.0.0.1:8118'
$ export https_proxy='https://127.0.0.1:8118'
$ env | grep proxy
http_proxy=http://127.0.0.1:8118
https_proxy=https://127.0.0.1:8118
$ curl ip.cn
当前 IP：149.28.57.192 来自：美国 Choopa
```

## 取消 curl 代理
```
$ unset http_proxy
$ unset https_proxy
$ curl ip.cn
当前 IP：180.168.17.114 来自：上海市 电信
```


## 设置 apt 代理
```
$ sudo tee /etc/apt/apt.conf << EOF
Acquire::http::Proxy "http://127.0.0.1:8118";
Acquire::https::Proxy "https://127.0.0.1:8118";
EOF
```
或
```
sudo tee /etc/apt/apt.conf << EOF
Acquire::http::Proxy "http://username:password@proxy.server:port";
Acquire::https::Proxy "https://username:password@proxy.server:port";
EOF
```
