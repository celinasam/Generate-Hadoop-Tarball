#!/bin/bash
# variaveis de ambiente para rodar o hadoop
export HADOOP_HOME=/opt/test/hadoop-0.21.0
export HADOOP_INSTALL=$HADOOP_HOME
# export PATH=$JAVA_HOME/bin:$HADOOP_HOME/bin:$PATH
export PATH=$HADOOP_HOME/bin:$PATH
# definir CLASSPATH
export CLASSPATH=.:$HADOOP_HOME/*:$HADOOP_HOME/lib/*
