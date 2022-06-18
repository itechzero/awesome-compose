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
cd $HOME/Your Project Name
docker-compose up -d
~~~
