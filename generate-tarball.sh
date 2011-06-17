#!/bin/bash

set -x
set -e

bin=`dirname "$0"`
bin=`cd "$bin"; pwd`

start_time=$(date +%s)

export VERSION=$1
export BRANCH=`echo ${VERSION:0:4}`

cd $2/hadoop-common/src/buildscripts

ln -s $2/hadoop-common common
ln -s $2/hadoop-hdfs hdfs
ln -s $2/hadoop-mapreduce mapred

make combined-tar

if [ -e $2/hadoop-common/build/hadoop-$VERSION.tar.gz ]; then
  rm $2/hadoop-common/build/hadoop-$VERSION.tar.gz
fi

if [ -e $2/hadoop-common/build/hadoop-combined.tar.gz ]; then
  rm $2/hadoop-common/build/hadoop-combined.tar.gz
fi

cd $2/hadoop-common/build

$bin/tar-munge $VERSION $2 $2/hadoop-{common,hdfs,mapreduce}/build/*$VERSION*.tar.gz

finish_time=$(date +%s)
echo "Time duration: $(($((finish_time - start_time))/60)) min $(($((finish_time - start_time))%60)) secs."
