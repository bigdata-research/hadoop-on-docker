FROM ubuntu:22.04

LABEL maintainer="Kevin BDA <kevinity310@gmail.com>"

# Update package lists and install necessary dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    software-properties-common 

# Install OpenJDK 8
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    openjdk-8-jdk 

# Install necessary tools for network connectivity
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    net-tools \
    curl \
    wget \
    netcat-openbsd \
    telnet \
    iputils-ping \
    nmap \
    tcpdump 

# Install necessary tools for development and debugging
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    gnupg \
    nano \
    lsof \
    htop \
    vim \
    wget \
    ssh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

# Set Hadoop version
ENV HADOOP_VERSION 3.3.6

# Import GPG keys from local file
COPY hadoop/${HADOOP_VERSION}/KEYS /tmp/KEYS
RUN gpg --import /tmp/KEYS

# Copy Hadoop tar file, its GPG signature, and its SHA-512 checksum from local to Docker image
COPY hadoop/${HADOOP_VERSION}/*.tar.gz /tmp/hadoop.tar.gz
COPY hadoop/${HADOOP_VERSION}/*.tar.gz.asc /tmp/hadoop.tar.gz.asc
COPY hadoop/${HADOOP_VERSION}/*.tar.gz.sha512 /tmp/hadoop.tar.gz.sha512

# Verify and extract Hadoop tar file
RUN set -x \
    && echo "$(awk -F'= ' '{print $2}' /tmp/hadoop.tar.gz.sha512) /tmp/hadoop.tar.gz" | sha512sum -c - \
    && gpg --verify /tmp/hadoop.tar.gz.asc /tmp/hadoop.tar.gz \
    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz*


# Create symbolic link to Hadoop configuration directory
RUN ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop

# Create directories for Hadoop logs and data
RUN mkdir /opt/hadoop-$HADOOP_VERSION/logs
RUN mkdir /hadoop-data

ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV MULTIHOMED_NETWORK=1
ENV USER=root
ENV PATH $HADOOP_HOME/bin/:$PATH

ADD entrypoint.sh /entrypoint.sh

RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

# docker build -t kevinity310/hadoop-base:dev .
# docker run -it --rm --name base-hadoop kevinity310/hadoop-base:dev /bin/bash
