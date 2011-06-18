#!/bin/bash

set -x
set -e

export VERSION=$1
export BRANCH=`echo ${VERSION:0:4}`

thisdir=`dirname "$0"`
thisdir=`cd "$thisdir"; pwd`

export HADOOP_HOME=$3/hadoop-$VERSION

export PATH=$HADOOP_HOME/bin:$PATH
export CLASSPATH=.:$HADOOP_HOME/*:$HADOOP_HOME/lib/*

cp $thisdir/conf/core-site.xml $HADOOP_HOME/conf
# cp $thisdir/conf/hdfs-site.xml $HADOOP_HOME/conf
# cp $thisdir/conf/mapred-site.xml $HADOOP_HOME/conf
if [[ $VERSION == "0.20.1-dev" ]]; then
  cp $thisdir/conf/hmon $HADOOP_HOME/conf
  cp $thisdir/conf/raidnode $HADOOP_HOME/conf
fi

mv $HADOOP_HOME/conf/hdfs-site.xml $HADOOP_HOME/conf/hdfs-site.xml.old
touch $HADOOP_HOME/conf/hdfs-site.xml
echo '<?xml version="1.0"?>' >> $HADOOP_HOME/conf/hdfs-site.xml
echo '<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>' >> $HADOOP_HOME/conf/hdfs-site.xml
echo '' >> $HADOOP_HOME/conf/hdfs-site.xml
echo '<configuration>' >> $HADOOP_HOME/conf/hdfs-site.xml
echo '  <property>' >> $HADOOP_HOME/conf/hdfs-site.xml
echo '    <name>dfs.namenode.name.dir</name>' >> $HADOOP_HOME/conf/hdfs-site.xml
echo "    <value>$2/test/$1/dfs/name</value>" >> $HADOOP_HOME/conf/hdfs-site.xml
echo '  </property>' >> $HADOOP_HOME/conf/hdfs-site.xml
echo '  <property>' >> $HADOOP_HOME/conf/hdfs-site.xml
echo '    <name>dfs.datanode.data.dir</name>' >> $HADOOP_HOME/conf/hdfs-site.xml
echo "    <value>$2/test/$1/dfs/data</value>" >> $HADOOP_HOME/conf/hdfs-site.xml
echo '  </property>' >> $HADOOP_HOME/conf/hdfs-site.xml
echo '  <property>' >> $HADOOP_HOME/conf/hdfs-site.xml
echo '    <name>dfs.datanode.address</name>' >> $HADOOP_HOME/conf/hdfs-site.xml
echo '    <value>0.0.0.0:50010</value>' >> $HADOOP_HOME/conf/hdfs-site.xml
echo '  </property>' >> $HADOOP_HOME/conf/hdfs-site.xml
echo '  <property>' >> $HADOOP_HOME/conf/hdfs-site.xml
echo '    <name>dfs.replication</name>' >> $HADOOP_HOME/conf/hdfs-site.xml
echo '    <value>1</value>' >> $HADOOP_HOME/conf/hdfs-site.xml
echo '  </property>' >> $HADOOP_HOME/conf/hdfs-site.xml
echo '  <property>' >> $HADOOP_HOME/conf/hdfs-site.xml
echo '    <name>dfs.web.ugi</name>' >> $HADOOP_HOME/conf/hdfs-site.xml
echo '    <value>hadoop,hadoop</value>' >> $HADOOP_HOME/conf/hdfs-site.xml
echo '  </property>' >> $HADOOP_HOME/conf/hdfs-site.xml
echo '</configuration>' >> $HADOOP_HOME/conf/hdfs-site.xml

mv $HADOOP_HOME/conf/mapred-site.xml $HADOOP_HOME/conf/mapred-site.xml.old
touch $HADOOP_HOME/conf/mapred-site.xml
echo '<?xml version="1.0"?>' >> $HADOOP_HOME/conf/mapred-site.xml
echo '<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>' >> $HADOOP_HOME/conf/mapred-site.xml
echo '' >> $HADOOP_HOME/conf/mapred-site.xml
echo '<configuration>' >> $HADOOP_HOME/conf/mapred-site.xml
echo '  <property>' >> $HADOOP_HOME/conf/mapred-site.xml
echo '    <name>mapred.job.tracker</name>' >> $HADOOP_HOME/conf/mapred-site.xml
echo '    <value>localhost:9001</value>' >> $HADOOP_HOME/conf/mapred-site.xml
echo '  </property>' >> $HADOOP_HOME/conf/mapred-site.xml
echo '  <property>' >> $HADOOP_HOME/conf/mapred-site.xml
echo '    <name>mapred.system.dir</name>' >> $HADOOP_HOME/conf/mapred-site.xml
echo "    <value>$2/test/$1/mapreduce/system</value>" >> $HADOOP_HOME/conf/mapred-site.xml
echo '  </property>' >> $HADOOP_HOME/conf/mapred-site.xml
echo '  <property>' >> $HADOOP_HOME/conf/mapred-site.xml
echo '   <name>mapred.local.dir</name>' >> $HADOOP_HOME/conf/mapred-site.xml
echo "   <value>$2/test/$1/mapreduce/local</value>" >> $HADOOP_HOME/conf/mapred-site.xml
echo '  </property>' >> $HADOOP_HOME/conf/mapred-site.xml
echo '  <property>' >> $HADOOP_HOME/conf/mapred-site.xml
echo '    <name>mapred.child.java.opts</name>' >> $HADOOP_HOME/conf/mapred-site.xml
echo '    <value>-Xmx512m</value>' >> $HADOOP_HOME/conf/mapred-site.xml
echo '  </property>' >> $HADOOP_HOME/conf/mapred-site.xml
echo '    <property>' >> $HADOOP_HOME/conf/mapred-site.xml
echo '    <name>webinterface.private.actions</name>' >> $HADOOP_HOME/conf/mapred-site.xml
echo '    <value>true</value>' >> $HADOOP_HOME/conf/mapred-site.xml
echo '  </property>' >> $HADOOP_HOME/conf/mapred-site.xml
echo '</configuration>' >> $HADOOP_HOME/conf/mapred-site.xml

echo "export JAVA_HOME=/usr/lib/jvm/java-6-sun" >> $HADOOP_HOME/conf/hadoop-env.sh
echo "export HADOOP_HOME="$HADOOP_HOME >> $HADOOP_HOME/conf/hadoop-env.sh
echo "export HADOOP_PID_DIR="$HADOOP_HOME"/pids" >> $HADOOP_HOME/conf/hadoop-env.sh
echo "export HADOOP_LOG_DIR="$HADOOP_HOME"/logs" >> $HADOOP_HOME/conf/hadoop-env.sh
echo "export HADOOP_IDENT_STRING=hadoop" >> $HADOOP_HOME/conf/hadoop-env.sh
echo "export HADOOP_CLASSPATH="$HADOOP_HOME"/lib" >> $HADOOP_HOME/conf/hadoop-env.sh
