#! /bin/bash
/hadoop/bin/hdfs namenode -format
/hadoop/sbin/start-all.sh
/hadoop/bin/hdfs dfs -mkdir /user/
/hadoop/bin/hdfs dfs -mkdir /user/root/
/hadoop/bin/hdfs dfs -put /hadoop/etc/hadoop input
/hadoop/bin/hdfs dfs -rm -r input/shellprofile.d