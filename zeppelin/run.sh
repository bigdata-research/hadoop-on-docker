#!/bin/bash

# For Service Zeppelin
hadoop fs -mkdir -p    /apps/zeppelin/notebooks

zeppelin-daemon.sh upstart
