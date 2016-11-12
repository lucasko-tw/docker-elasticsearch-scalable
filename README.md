## Dockerfile for Elasticsearch 2.3 with customize elasticsearch.yml
This is a example for runing elasticsearch 2.3 container and dynamic import customize elasticsearch.yml


### elasticsearch.yml of Master node (In the config-master/ folder)

```yml
network.host: 0.0.0.0
cluster.name: "lucasko"
node.name: "masterNode"
node.master: true
node.data: true
path.data: /data/data
path.logs: /data/logs
```

### elasticsearch.yml of Slave node  (In the config-slave/ folder)

```yml
network.host: 0.0.0.0
cluster.name: "lucasko"
node.data: true
path.data: /data/data
path.logs: /data/logs
```

### Build image

```sh
		docker build -t es:1.0 . 
```

### docker-compose.yml

```yml
es_master:
  image: es:1.0
  user: elsearch
  ports:
    - "9200:9200" 
    - "9300:9300" 
  volumes:
    - $PWD/data:/data
    - $PWD/config-master:/elasticsearch/config 
  command: "/elasticsearch/bin/elasticsearch"
  restart: always


es_slave:
  image: es:1.0
  user: elsearch
  links:
    - es_master
  volumes:
    - $PWD/data:/data
    - $PWD/config-slave:/elasticsearch/config 
  command: "/elasticsearch/bin/elasticsearch -Des.discovery.zen.ping.unicast.hosts=es_master:9300"
  restart: always
```

1. es_slave uses "-Des.discovery.zen.ping.unicast.hosts" to find out master node and join cluster.


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
	
```

![One master and three slaves ](https://github.com/lucasko-tw/docker-compose-elasticsearch-cluster-scale/blob/master/one-master-three-slaves.png)


