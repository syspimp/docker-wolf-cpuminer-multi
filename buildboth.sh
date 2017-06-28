#!/bin/bash
./buildandpush.sh
pushd etcd-container
./rebuild.sh
popd
