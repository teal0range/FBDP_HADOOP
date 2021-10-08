#! /bin/bash

generateHostFile(){
    basehost=$(cat hosts)
    for cnt in $(seq $1)
    do
    basehost=`echo -e "$basehost\n172.19.0.$(($cnt+1)) host$cnt"`
    done
    echo "$basehost"
}

generateHostList(){
    hostList="host1"
    for cnt in $(seq 2 $1)
    do
    hostList=`echo -e "$hostList\nhost$cnt"`
    done
    echo "$hostList"
}

generateHostFile $1 > resources/hosts
generateHostList $1 > hadoop-3.2.2/etc/hadoop/workers

docker build -t hadoop .

if [ $(docker network ls | grep hadoop-net |wc -l) -eq 0 ];then
    docker network create hadoop-net
fi

docker rm -f $(docker ps -a|awk '/hadoop/ {print $1}')

for cnt in $(seq $1)
do   
    if [ $cnt -eq 1 ];then
        docker run -itd -v /root/hadoop-install/hadoop-3.2.2:/hadoop -p 9870:9870 -p 8088:8088 --network=hadoop-net --hostname host$cnt --name hadoop-host$cnt hadoop bash
    else
        docker run -itd -v /root/hadoop-install/hadoop-3.2.2:/hadoop --network=hadoop-net --hostname host$cnt --name hadoop-host$cnt hadoop bash
    fi
    
    docker exec -d hadoop-host$cnt sh /root/init.sh
done

# 初始化HDFS
docker exec hadoop-host1 sh /root/formatHDFS.sh
docker exec hadoop-host1 /hadoop/bin/hadoop jar /hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.2.2.jar wordcount input output
# docker exec hadoop-host1 /hadoop/sbin/stop-all.sh
