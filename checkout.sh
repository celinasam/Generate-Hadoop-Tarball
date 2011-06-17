#!/bin/bash

set -x
set -e

start_time=$(date +%s)

export VERSION=$1
export BRANCH=`echo ${VERSION:0:4}`

cd $2
svn checkout https://svn.apache.org/repos/asf/hadoop/common/branches/branch-$BRANCH/common hadoop-common > check-common.out 2>&1
svn checkout https://svn.apache.org/repos/asf/hadoop/common/branches/branch-$BRANCH/hdfs hadoop-hdfs > check-hdfs.out 2>&1
svn checkout https://svn.apache.org/repos/asf/hadoop/common/branches/branch-$BRANCH/mapreduce hadoop-mapreduce > check-mapreduce.out 2>&1

finish_time=$(date +%s)
echo "Time duration: $(($((finish_time - start_time))/60)) min $(($((finish_time - start_time))%60)) secs."
