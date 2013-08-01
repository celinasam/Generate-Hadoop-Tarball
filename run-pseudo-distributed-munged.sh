#!/bin/bash
# First run:
# ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa
# cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys
# echo 'export JAVA_HOME=/usr/java/jdk1.6.0_14' >> ~/.bashrc

# set -x
set -e

export VERSION=$1
export BRANCH=`echo ${VERSION:0:4}`

# thisdir=`dirname "$0"`
thisdir=`pwd`
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

if [[ $VERSION == "0.20.1-dev" ]]; then
 tar zxf ../hadoop-$VERSION-bin.tar.gz
else
 if [[ $VERSION == "0.20.203.0" ]]; then
   tar zxf ../hadoop-$VERSION"rc1.tar.gz"
 else
   tar zxf ../hadoop-$VERSION.tar.gz
 fi
fi

export HADOOP_HOME=$testdir/hadoop-$VERSION

export PATH=$HADOOP_HOME/bin:$PATH
export CLASSPATH=.:$HADOOP_HOME/*:$HADOOP_HOME/lib/*

$thisdir/source/Generate-Hadoop-Tarball-master/conf-files.sh $VERSION $2 $testdir

mkdir $2/test/$VERSION/mapreduce
mkdir $2/test/$VERSION/mapreduce/system
mkdir $2/test/$VERSION/mapreduce/local
mkdir $2/test/$VERSION/dfs
mkdir $2/test/$VERSION/dfs/name
mkdir $2/test/$VERSION/dfs/data
mkdir $2/test/$VERSION/dfs/client

rm -rf /tmp/hadoop-$USER

if [[ $BRANCH == "0.20"  ]]; then
  $HADOOP_HOME/bin/hadoop namenode -format
else
  $HADOOP_HOME/bin/hdfs namenode -format
fi

$HADOOP_HOME/bin/start-dfs.sh

if [[ $BRANCH == "0.20"  ]]; then
  $HADOOP_HOME/bin/hadoop dfsadmin -safemode wait
else
  $HADOOP_HOME/bin/hdfs dfsadmin -safemode wait
fi

$HADOOP_HOME/bin/start-mapred.sh

sleep 60

$HADOOP_HOME/bin/hadoop fs -mkdir input
$HADOOP_HOME/bin/hadoop fs -copyFromLocal $HADOOP_HOME/LICENSE.txt input
$HADOOP_HOME/bin/hadoop fs -ls input
$HADOOP_HOME/bin/hadoop fs -cat input/LICENSE.txt
if [[ $VERSION == "0.20.1-dev" ]]; then
    $HADOOP_HOME/bin/hadoop jar $HADOOP_HOME/hadoop-$VERSION-examples.jar grep \
    input output Apache
else
  if [[ $VERSION == "0.20.203.0" ]]; then
    $HADOOP_HOME/bin/hadoop jar $HADOOP_HOME/hadoop-examples-$VERSION.jar grep \
    input output Apache
  else
    if [[ $VERSION == "0.21.1" || $VERSION == "0.22.0" ]]; then
      $HADOOP_HOME/bin/hadoop jar $HADOOP_HOME/hadoop-mapred-examples-$VERSION-SNAPSHOT.jar grep \
      input output Apache
    else
      $HADOOP_HOME/bin/hadoop jar $HADOOP_HOME/hadoop-mapred-examples-$VERSION.jar grep \
      input output Apache
    fi
  fi
fi

# following returns a non-zero exit code if no match
if [[ $BRANCH == "0.20" ]]; then
  $HADOOP_HOME/bin/hadoop fs -cat 'output/part-00000' | grep Apache
else
  $HADOOP_HOME/bin/hadoop fs -cat 'output/part-r-00000' | grep Apache
fi

$HADOOP_HOME/bin/stop-mapred.sh
$HADOOP_HOME/bin/stop-dfs.sh
