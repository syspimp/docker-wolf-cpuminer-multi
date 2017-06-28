#!/bin/bash -x
POOLID="stratum+tcp://us-east.multipool.us:7777"
USER="multipimpin.worker"
START=30
ADD=10
LIMIT=90
#CMDLINE="/usr/local/bin/minerd -a scrypt -o"
CMDLINE="/opt/minerd -o"

while getopts "dp:u:e:h" OPTION
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
                h) /usr/local/bin/minerd -h ; /bin/bash
               ;;
        esac
done

main()
{
        # code goes heee
        printenv
        if [ ! -z "$KUBERNETES_SERVICE_PORT" ]
        then
          echo "working in openshift, lets check for other pods and etcd server"
          if [ ! -z "$ETCD_SERVER" ]
          then
            echo "yes! we have an etcd server, lets orchestrate..."
            #find / -name 'curl' -type f
            while RESULT=$(/usr/bin/curl -s ${ETCD_SERVER}/v2/keys/${USER}${START})
            do
              if [ `echo $RESULT |grep registered` ]
              then
                 echo "not found, adding 10 ( ${USER}${START})"
                 START=$(( START + ADD ))
              else
                 echo "found a free name: ${USER}${START}"
                 USER="${USER}${START}"
                 /usr/bin/curl -s -X PUT ${ETCD_SERVER}/v2/keys/${USER} -d value="registered"
                 break;
              fi
              if [ ${START} -gt ${LIMIT} ]
              then
                echo "passed the limit of ${LIMIT}"
                exit 1;
              fi
            done
            $CMDLINE $POOLID -u ${USER}
          else
            echo "in openshift, but no etcd server doing solo work ..."
            $CMDLINE $POOLID -u ${USER}${START}
          fi
        else
          echo "not in openshift, doing solo work ..."
          $CMDLINE $POOLID -u ${USER}${START}
        fi
}
main
exit 0
