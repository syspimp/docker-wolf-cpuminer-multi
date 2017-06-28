#!/bin/bash
project="redhat-lab"
ose_user="admin"
ose_pass="redhat123"
container="etcd-container"
docker build --no-cache -t $container .
oc login -u $ose_user -p $ose_pass
id=$(docker images|grep ^$container|awk '{print $3}')
server=$(oc get svc|grep docker-reg| awk '{print $2}')
token=$(oc whoami -t)
docker login -u $ose_user -p $token ${server}:5000
docker tag $container ${server}:5000/${project}/${container}
docker push ${project}:5000/${project}/${container}
