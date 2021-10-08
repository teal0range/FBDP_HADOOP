FROM ubuntu

RUN apt -y update 2>>/dev/null \
    && apt -y install openssh-server \
    && apt -y install openjdk-8-jdk-headless\ 
    && ssh-keygen -t rsa -f /root/.ssh/id_rsa\
    && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys\
    && mkdir /hadoop

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/\
    HDFS_NAMENODE_USER=root\
    HDFS_DATANODE_USER=root\
    HDFS_SECONDARYNAMENODE_USER=root\
    YARN_RESOURCEMANAGER_USER=root\
    YARN_NODEMANAGER_USER=root

COPY ./resources/* /root/

