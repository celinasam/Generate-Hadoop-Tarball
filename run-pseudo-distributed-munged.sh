#!/bin/bash
# First run:
# ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa
# cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys
# echo 'export JAVA_HOME=/usr/java/jdk1.6.0_14' >> ~/.bashrc

set -x
set -e

export VERSION=$1
export BRANCH=`echo ${VERSION:0:4}`

thisdir=`dirname "$0"`
thisdir=`cd "$thisdir"; pwd`

if [ -d "test" ]; then
   if [ -d test/$VERSION ]; then
     rm -rf test/$VERSION
     mkdir test/$VERSION
   else
     mkdir test/$VERSION
   fi
else
   mkdir test
   mkdir test/$VERSION
fi

pushd test

testdir=`pwd`

tar zxf ../hadoop-$VERSION.tar.gz

export HADOOP_HOME=$testdir/hadoop-$VERSION

export PATH=$HADOOP_HOME/bin:$PATH
export CLASSPATH=.:$HADOOP_HOME/*:$HADOOP_HOME/lib/*

$thisdir/conf-files.sh $VERSION $2 $testdir

mkdir $2/test/$VERSION/mapreduce
mkdir $2/test/$VERSION/mapreduce/system
mkdir $2/test/$VERSION/mapreduce/local
mkdir $2/test/$VERSION/dfs
mkdir $2/test/$VERSION/dfs/name
mkdir $2/test/$VERSION/dfs/data
mkdir $2/test/$VERSION/dfs/client

rm -rf /tmp/hadoop-$USER
$HADOOP_HOME/bin/hdfs namenode -format

$HADOOP_HOME/bin/start-dfs.sh

$HADOOP_HOME/bin/hdfs dfsadmin -safemode wait

$HADOOP_HOME/bin/start-mapred.sh

sleep 60

$HADOOP_HOME/bin/hadoop fs -mkdir input
$HADOOP_HOME/bin/hadoop fs -copyFromLocal $HADOOP_HOME/LICENSE.txt input
$HADOOP_HOME/bin/hadoop fs -ls input
$HADOOP_HOME/bin/hadoop fs -cat input/LICENSE.txt
$HADOOP_HOME/bin/hadoop jar $HADOOP_HOME/hadoop-mapred-examples-$VERSION.jar grep \
  input output Apache

# following returns a non-zero exit code if no match
$HADOOP_HOME/bin/hadoop fs -cat 'output/part-r-00000' | grep Apache

$HADOOP_HOME/bin/stop-mapred.sh
$HADOOP_HOME/bin/stop-dfs.sh
