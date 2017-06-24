#!/bin/bash
POOLID="stratum+tcp://us-east.multipool.us:7777"
USER="multipimpin.worker"
START=30
ADD=10
LIMIT=90
while getopts "dp:u:" OPTION
do
        case "$OPTION" in
                # debug
                d) set -x
                ;;
                p) POOLID=$OPTARG
                ;;
                u) USER=$OPTARG
               ;;
                e) ETCD_SERVER=$OPTARG
               ;;
        esac
done

main()
{
        # code goes heee
        printenv
        if [ ! -z "$OPENSHIFT_BUILD_NAME" ]
        then
          echo "working in openshift, lets check for other pods and etcd server"
          if [ ! -z "$ETCD_SERVER" ]
          then
            echo "yes! we have an etcd server, lets orchestrate..."
            while RESULT=$(curl -s ${ETCD_SERVER}/v2/keys/${USER}${START})
            do
              if [ `echo $RESULT |grep registered` ]
              then
                 START=$(( START + ADD ))
              else
                 echo "found a free name: ${USER}${START}"
                 USER="${USER}${START}"
                 curl -s -X PUT ${ETCD_SERVER}/v2/keys/${USER} -d value="registered"
                 break;
              fi
              if [ ${START} -gt ${LIMIT} ]
              then
                echo "passed the limit of ${LIMIT}"
                exit 1;
              fi
            done
            /opt/minerd -o $POOLID -u ${USER} -p x
          else
            echo "in openshift, but no etcd server doing solo work ..."
            /opt/minerd -o $POOLID -u ${USER}${START} -p x
          fi
        else
          echo "not in openshift, doing solo work ..."
          /opt/minerd -o $POOLID -u ${USER}${START} -p x
        fi
}
main
exit 0
