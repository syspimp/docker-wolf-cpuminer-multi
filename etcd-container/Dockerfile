FROM quay.io/coreos/etcd:v3.0.16
EXPOSE 22379
ENTRYPOINT /usr/local/bin/etcd -advertise-client-urls http://0.0.0.0:22379 -listen-client-urls http://0.0.0.0:22379 -data-dir /tmp
#CMD ['-advertise-client-urls','http://0.0.0.0:22379','-listen-client-urls','http://0.0.0.0:22379']
