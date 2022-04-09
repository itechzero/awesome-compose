# DevEnv
Quick Create a Development Environment

## Support
- redis
- mongo
- mysql
- zookeeper & zookeeper-ui
- rabbitmq
- nats
- kafka & kafka-manager
- elasticsearch
- jaeger
- prometheus
- grafana
- vault

## Use
~~~
docker network create -d bridge dev-network
~~~

~~~
git clone https://github.com/itechzero/DevEnv.git $HOME/Your Project Name
~~~

~~~
cd $HOME/Your Project Name
docker-compose up -d
~~~

### go install
~~~
source scripts/go.sh
source scripts/go.sh -v 1.17.2
~~~

### 可能遇到的问题
grafana文件夹权限不够
~~~
sudo chmod -R 777 $HOME/Project Name/data/grafana/*
~~~
