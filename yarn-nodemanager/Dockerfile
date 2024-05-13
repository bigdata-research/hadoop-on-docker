FROM kevinity310/hadoop-base:dev

LABEL maintainer="Kevin BDA <kevinity310@gmail.com>"

HEALTHCHECK CMD curl -f http://localhost:8042/ || exit 1

# Install python 
# Update package lists and install necessary dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y \
    python3.10 \
    python3.10-dev \
    python3-pip \
    python3.10-venv \
    python3.10-distutils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Optionally, set Python 3.10 as the default python version
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1

# Verify Python and pip installation
RUN python3 --version && pip3 --version

RUN echo "Install Package Required for Pyspark"
COPY spark/requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt

ENV SPARK_VERSION 3.4.2
ENV HIVE_VERSION 3.1.3
ENV TEZ_VERSION 0.9.2

# ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"

ENV SPARK_HOME=/opt/spark-${SPARK_VERSION}
RUN mkdir -p $SPARK_HOME
WORKDIR $SPARK_HOME

COPY spark/${SPARK_VERSION}/KEYS /tmp/KEYS
RUN gpg --import /tmp/KEYS

# Copy Spark tar file, its GPG signature, and its SHA-512 checksum from local to Docker image
COPY spark/${SPARK_VERSION}/*.tgz /tmp/spark.tgz
COPY spark/${SPARK_VERSION}/*.tgz.asc /tmp/spark.tgz.asc
COPY spark/${SPARK_VERSION}/*.tgz.sha512 /tmp/spark.tgz.sha512

# Verify and extract Spark tar file
RUN set -x \
    && echo "$(cat /tmp/spark.tgz.sha512) /tmp/spark.tgz" | sha512sum -c  \
    && gpg --verify /tmp/spark.tgz.asc /tmp/spark.tgz  \
    && tar xvzf /tmp/spark.tgz --directory ${SPARK_HOME} --strip-components 1 \
    && rm -rf /tmp/spark.tgz*

RUN mkdir -p /etc/spark

# Create symbolic link to Spark configuration directory
RUN ln -s $SPARK_HOME/conf /etc/spark/conf
RUN ln -s $SPARK_HOME/jars /etc/spark/jars
RUN ln -s $SPARK_HOME/yarn /etc/spark/yarn
RUN ln -s $SPARK_HOME/python /etc/spark/python

RUN cp /etc/spark/conf/spark-defaults.conf.template /etc/spark/conf/spark-defaults.conf
# RUN cp /etc/spark/conf/fairscheduler.xml.template /etc/spark/conf/fairscheduler.xml

# file config: fairscheduler.xml.template  log4j2.properties.template  metrics.properties.template  spark-defaults.conf.template  spark-env.sh.template  workers.template

# Set environment variables for spark
ENV PATH ${SPARK_HOME}/sbin/:${SPARK_HOME}/bin:$PATH
ENV SPARK_CONF_DIR=/etc/spark/conf



# =================================================================================
# INSTALL HIVE
# COPY hive/${HIVE_VERSION}/KEYS /tmp/KEYS

# RUN gpg --import /tmp/KEYS

# ENV HIVE_HOME /opt/hive-$HIVE_VERSION

# COPY hive/${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz /tmp/hive.tar.gz
# COPY hive/${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz.asc /tmp/hive.tar.gz.asc
# COPY hive/${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz.sha256 /tmp/hive.tar.gz.sha256

# RUN set -x \
#     && echo "$(cat /tmp/hive.tar.gz.sha256) /tmp/hive.tar.gz" | sha256sum -c  \
#     && gpg --verify /tmp/hive.tar.gz.asc /tmp/hive.tar.gz  \
#     && tar xvzf /tmp/hive.tar.gz --directory /opt/ --strip-components 1 \
#     && rm -rf /tmp/hive.tar.gz* \
#     && ls -la /opt/

# RUN mv /opt/apache-hive-$HIVE_VERSION-bin ${HIVE_HOME}

# RUN ln -s ${HIVE_HOME}/conf /etc/hive

# RUN mkdir ${HIVE_HOME}/logs

# # Set environment variables
# ENV PATH $HIVE_HOME/bin:$PATH

# # # Remove existing Guava JAR from $HIVE_HOME/lib
# RUN rm $HIVE_HOME/lib/guava-19.0.jar

# # # Copy the appropriate Guava JAR from $HADOOP_HOME/share/hadoop/hdfs/lib to $HIVE_HOME/lib
# RUN cp $HADOOP_HOME/share/hadoop/hdfs/lib/guava-27.0-jre.jar $HIVE_HOME/lib/

# COPY hive/conf/* $HIVE_HOME/conf/

# WORKDIR /

# # Adding Tez
# RUN curl -O https://dist.apache.org/repos/dist/release/tez/KEYS

# RUN gpg --import KEYS

# ENV TEZ_URL https://dist.apache.org/repos/dist/release/tez/${TEZ_VERSION}/apache-tez-${TEZ_VERSION}-bin.tar.gz
# ENV TEZ_HOME /opt/tez-$TEZ_VERSION
# ENV TEZ_CONF_DIR=$TEZ_HOME/conf
# ENV HADOOP_CLASSPATH=${TEZ_HOME}/conf:${TEZ_HOME}/*:${TEZ_HOME}/lib/*

# RUN set -x \
#     && curl -fSL "$TEZ_URL" -o /tmp/tez.tar.gz \
#     && tar -xvf /tmp/tez.tar.gz -C /opt/ \
#     && rm /tmp/tez.tar.gz*

# RUN mv /opt/apache-tez-${TEZ_VERSION}-bin ${TEZ_HOME}

# RUN ln -s ${TEZ_HOME}/conf /etc/tez

# RUN mkdir ${TEZ_HOME}/logs

# COPY tez/conf/* ${TEZ_HOME}/conf/

ADD entrypoint.sh /entrypoint.sh

RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

# ADD run.sh /run.sh
# RUN chmod a+x /run.sh

# EXPOSE 8042

# CMD ["/run.sh"]

# docker build -t kevinity310/hadoop-nodemanager:dev .
# docker run -it --rm --name test-yarn-nodemanager kevinity310/hadoop-nodemanager:dev /bin/bash 

# docker run -it --rm --name test-yarn-nodemanager --env-file hadoop-host-dev.env kevinity310/hadoop-nodemanager:dev /bin/bash 

