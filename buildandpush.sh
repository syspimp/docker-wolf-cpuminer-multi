#!/bin/bash -x
#docker build -t cpuminer-multipool .
docker build --no-cache -t cpuminer-multipool .
oc login -u admin -p redhat123
id=$(docker images|grep ^cpuminer|awk '{print $3}')
pass=$(oc whoami -t)
server=$(oc get svc|grep docker-reg| awk '{print $2}')
docker login -u admin -p $pass ${server}:5000
docker tag $id ${server}:5000/redhat-lab/cpuminer-multipool
docker push ${server}:5000/redhat-lab/cpuminer-multipool

