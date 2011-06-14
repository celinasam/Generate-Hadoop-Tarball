#!/bin/bash

set -x
set -e

export VERSION=$1
export BRANCH=`echo ${VERSION:0:4}`

mkdir $2/test/$VERSION/hdfs
mkdir $2/test/$VERSION/hdfs/DFS/
mkdir $2/test/$VERSION/hdfs/DFS/conf
cp -Rp /home/hadoop/Download/hadoop-tarball/conf/raid.xml $2/test/$VERSION/hdfs/DFS/conf
mkdir /opt/test/$VERSION/dfs1
mkdir /opt/test/$VERSION/dfs2
if [[ $VERSION == "0.20.1"  ]]; then
  export HADOOP_HOME=$2/test/hadoop-$VERSION-dev
else
  export HADOOP_HOME=$2/test/hadoop-$VERSION
fi
cd $HADOOP_HOME
chmod +x $2/hadoop-mapreduce/src/contrib/raid/bin/*raidnode*.sh
cp -Rp $2/hadoop-mapreduce/src/contrib/raid/bin/*raidnode*.sh bin
if [[ $VERSION == "0.20.1"  ]]; then
  cp -Rp $HADOOP_HOME/contrib/raid/hadoop-*-raid.jar $HADOOP_HOME/lib
else
  cp -Rp $HADOOP_HOME/mapred/contrib/raid/hadoop-*-raid.jar $HADOOP_HOME/lib
fi
