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

## Use
~~~
docker network create -d bridge dev-network
~~~

~~~
git clone https://github.com/itechzero/DevEnv.git Your Project Name
~~~

~~~
cd Your Project Name
docker-compose up -d
~~~

### go install
~~~
source sh/go.sh
source sh/go.sh -v 1.17.2
~~~