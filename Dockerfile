FROM java:8-jdk

ENV ES_VERSION=2.3.0


ADD https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/$ES_VERSION/elasticsearch-$ES_VERSION.tar.gz /tmp/es.tgz
#COPY ./elasticsearch-2.3.0.tar.gz /tmp/es.tgz

RUN tar xvf /tmp/es.tgz   && \
  rm /tmp/es.tgz


ENV ES_HOME=/elasticsearch

RUN mv ./elasticsearch-$ES_VERSION $ES_HOME


ENV ES_HOME=$ES_DIR/elasticsearch \
    OPTS=-Dnetwork.host=_non_loopback_ \
    DEFAULT_ES_USER=elsearch

RUN $ES_HOME/bin/plugin install mobz/elasticsearch-head

WORKDIR $ES_HOME

RUN groupadd elsearch
RUN useradd elsearch -g elsearch -p elasticsearch
RUN chown -R elsearch:elsearch  $ES_HOME


# Define mountable directories.
VOLUME ["/data" , "/elasticsearch/config" ]

# Mount elasticsearch.yml config
#ADD config/elasticsearch.yml /elasticsearch/config/elasticsearch.yml

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["/elasticsearch/bin/elasticsearch"]

EXPOSE 9200
EXPOSE 9300
