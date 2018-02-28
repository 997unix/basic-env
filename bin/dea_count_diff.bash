#!/bin/bash
SLEEP_TIME=${SLEEP_TIME:-8m}
MAX_RUN=${MAX_RUN:-10}
TOOLS_REPO_PATH=$HOME/cf/tools

DEPLOYMENT=$( bosh --no-color deployment | awk {'print $NF'} |tr -d \' | tr -d \`);
NATS=$(${TOOLS_REPO_PATH}/utils/get-nats-uri $DEPLOYMENT)

if [[ -z "$NATS" ]]; then
    echo "ERROR: \$NATS is not set, exiting"
    exit 2
fi

function cleanup(){
    echo "caught SIG"
    echo "INFO: Running app count: $(wc -l $o)"
    echo "EXITING"
    cd -
    exit 1
}

function show_running_app_count () {
    echo "INFO: Running app count: $(wc -l $o)"
}

trap cleanup HUP INT QUIT ILL TRAP KILL BUS TERM
trap show_running_app_count HUP USR1

for i in $(seq 1 $MAX_RUN); do
    o > /dev/null
    cd $TOOLS_REPO_PATH/utils
    dea_apps | egrep 'vcsops|cloudfoundry' | awk '{print $1}' | sort > $o
    if [[ $i > 1 ]]; then
        diff -u $o1 $o && \
            echo "INFO: Round $i [running apps $(wc -l $o|awk '{print $1}')]: No diffs between $(basename $o1) and $(basename $o)"
    else
        echo "INFO: Round $i [running apps $(wc -l $o|awk '{print $1}')]"
    fi
    cd -
    sleep $SLEEP_TIME
done
