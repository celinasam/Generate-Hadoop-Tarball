#!/bin/bash -x
#
#  Licensed to the Apache Software Foundation (ASF) under one or more
#  contributor license agreements.  See the NOTICE file distributed with
#  this work for additional information regarding copyright ownership.
#  The ASF licenses this file to You under the Apache License, Version 2.0
#  (the "License"); you may not use this file except in compliance with
#  the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
#
#  Not intended for direct use by end-users. This is called by the Makefile
#  with:
#    ./combine-bindirs.sh COMMON_SRC_HOME COMBINED_TARGET_NAME RSYNC_CMD
#  and it merges the directories created with 'ant binary' together into
#  a directory named by COMBINED_TARGET_NAME

commonsrc=$1
targetname=$2
rsynccmd=$3

pushd ${commonsrc}/build/
BUILD_SUBDIR_NAMES=`find . -maxdepth 1 -type d -name "hadoop-*"`
mkdir -p ${targetname}
for subdir in ${BUILD_SUBDIR_NAMES}; do
  if [ "${subdir}" != "${targetname}" ]; then
    ${rsynccmd} ${subdir}/* ${targetname}
  fi
done

# Now that we've merged the binary directories, their overlapped lib/
# directories will contain some unnecessary stuff.
# For example, mapred puts hadoop-hdfs-*.jar and hadoop-core-*.jar
# files in there, which will interfere with the proper versions we
# just built. Remove these.
rm ${targetname}/lib/hadoop-*.jar

# Also, there are some other libraries in there that have incompatible
# versions due to Ivy inconsistency.
# TODO / XXX / HACK -- This should really be reconciled by fixing the
# ivy.xml files of the various projects.
if [ -e ${targetname}/lib/aspectjrt-1.6.4.jar ]; then
  rm ${targetname}/lib/aspectjrt-1.6.4.jar # 1.6.5
fi
if [ -e ${targetname}/lib/aspectjtools-1.6.4.jar ]; then
  rm ${targetname}/lib/aspectjtools-1.6.4.jar # 1.6.5
fi
if [ -e ${targetname}/lib/avro-1.0.0.jar ]; then
  rm ${targetname}/lib/avro-1.0.0.jar # 1.2.0
fi
if [ -e ${targetname}/lib/slf4j-api-1.4.3.jar ]; then
  rm ${targetname}/lib/slf4j-api-1.4.3.jar # 1.5.8
fi
if [ -e ${targetname}/lib/slf4j-log4j12-1.4.3.jar ]; then
  rm ${targetname}/lib/slf4j-log4j12-1.4.3.jar # simple-1.5.8
fi
if [ -e ${targetname}/lib/jets3t-0.6.1.jar ]; then
  rm ${targetname}/lib/jets3t-0.6.1.jar # 0.7.1
fi

