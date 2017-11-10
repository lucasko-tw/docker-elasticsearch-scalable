##  scaling elasticsearch nodes to cluster
This is a example for scaling es's nodes by docker-compose 

## Quick Start

```
git clone https://github.com/lucasko-tw/docker-elasticsearch-scalable.git

cd docker-elasticsearch-scalable/

docker pull lucasko/elasticsearch

docker-compose up -d
```

### docker-compose.yml

```yml
es_master:
  image: lucasko/elasticsearch
  ports:
    - "9200:9200" 
    - "9300:9300" 
  volumes:
    - $PWD/config-master:/usr/share/elasticsearch/config 
  restart: always


es_slave:
  image: lucasko/elasticsearch
  links:
    - es_master
  volumes:
    - $PWD/config-slave:/usr/share/elasticsearch/config
  command: "-Des.discovery.zen.ping.unicast.hosts=es_master:9300"
  restart: always
```

notes: es_slave uses "-Des.discovery.zen.ping.unicast.hosts" to find out master node and join cluster.



### config-master/elasticsearch.yml (Master)

```yml
network.host: 0.0.0.0
cluster.name: "lucasko"
node.name: "masterNode"
node.master: true
node.data: true
```

### config-slave/elasticsearch.yml (slave)


```yml
network.host: 0.0.0.0
cluster.name: "lucasko"
node.data: true
```
### Run docker-compose

```sh
   docker-compose up -d 
```

### To connect  _plugin/head

		http://localhost:9200/_plugin/head/


![One master and one slave ](https://github.com/lucasko-tw/docker-compose-elasticsearch-cluster-scale/blob/master/one-master-one-slave.png)

	
### Scale slave to 3 nodes

```sh
   docker-compose scale es_slave=3
   docker-compose scale es_slave=1	
```

![One master and three slaves ](https://github.com/lucasko-tw/docker-compose-elasticsearch-cluster-scale/blob/master/one-master-three-slaves.png)


