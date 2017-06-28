pass=$(oc whoami -t)
#docker build -t cpuminer-multipool .
docker build --no-cache -t cpuminer-multipool .
id=$(docker images|grep ^cpuminer|awk '{print $3}')
docker tag $id 172.30.7.173:5000/redhat-lab/cpuminer-multipool
docker push 172.30.7.173:5000/redhat-lab/cpuminer-multipool

#docker login -u admin -p TuNBh1fwpkES5wQvefj1kPsq-7PdRmfka3kPqjsGnwQ 172.30.7.173:5000
