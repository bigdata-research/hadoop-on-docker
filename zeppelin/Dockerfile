FROM --platform=linux/amd64 kevinity310/hadoop-nodemanager:dev

LABEL maintainer="kevinity310"

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost:9995/ || exit 1

# Adding Zeppelin
RUN curl -O https://dist.apache.org/repos/dist/release/zeppelin/KEYS
RUN gpg --import KEYS

ENV ZEPPELIN_VERSION 0.11.0
ENV ZEPPELIN_HOME /opt/zeppelin-${ZEPPELIN_VERSION}
ENV ZEPPELIN_URL https://dist.apache.org/repos/dist/release/zeppelin/zeppelin-${ZEPPELIN_VERSION}/zeppelin-${ZEPPELIN_VERSION}-bin-all.tgz

RUN set -x \
    && curl -fSL "$ZEPPELIN_URL" -o /tmp/zeppelin.tar.gz \
    && curl -fSL "$ZEPPELIN_URL.asc" -o /tmp/zeppelin.tar.gz.asc \
    && gpg --verify /tmp/zeppelin.tar.gz.asc \
    && tar -xvf /tmp/zeppelin.tar.gz -C /opt/ \
    && rm /tmp/zeppelin.tar.gz*

RUN mv /opt/zeppelin-${ZEPPELIN_VERSION}-bin-all ${ZEPPELIN_HOME}

RUN ln -s ${ZEPPELIN_HOME}/conf /etc/zeppelin

RUN mkdir -p ${ZEPPELIN_HOME}/logs

COPY conf/* ${ZEPPELIN_HOME}/conf/

RUN chmod 755 ${ZEPPELIN_HOME}/conf/* 

# Set environment variables for zeppelin
ENV PATH ${ZEPPELIN_HOME}/sbin/:${ZEPPELIN_HOME}/bin:${PATH}

WORKDIR /

ADD entrypoint.sh /entrypoint.sh

RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 9995
EXPOSE 9443

CMD ["/run.sh"]

# docker build -t kevinity310/zeppelin:dev .
# docker run -it --rm --name test-zeppelin kevinity310/zeppelin:dev /bin/bash 

# docker run -it --rm --name test-hive-server --env-file hadoop-port-dev.env kevinity310/hive:dev /bin/bash 