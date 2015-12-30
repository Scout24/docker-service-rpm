#!/bin/bash

DOCKER_EXTRA_ARGS="REPLACE_RUNARGS"
DOCKER_IMAGE="REPLACE_IMAGE"
DOCKER_NAME="REPLACE_NAME"

# chkconfig: 2345 99 99
# description: Docker container schlomo as Linux service
# processname: schlomo

### BEGIN INIT INFO
# Provides:          schlomo
# Required-Start:    $local_fs $network $remote_fs docker
# Required-Stop:     $local_fs $network $remote_fs docker
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Docker container schlomo as Linux service
# Description:       Wrapper to run a Docker container as a Linux service
### END INIT INFO

DOCKER_ARGS=""

function start {
	if ! status &>/dev/null ; then
        docker $DOCKER_ARGS rm -f $DOCKER_NAME &>/dev/null
		docker $DOCKER_ARGS rmi -f $DOCKER_IMAGE &>/dev/null
		docker $DOCKER_ARGS load </usr/share/$DOCKER_NAME/image
		docker $DOCKER_ARGS run -d $DOCKER_EXTRA_ARGS --name $DOCKER_NAME $DOCKER_IMAGE
		echo "Started container $DOCKER_NAME"
	else
		echo "Container $DOCKER_NAME is already running"
	fi
	status
}

function stop {
	docker $DOCKER_ARGS stop $DOCKER_NAME &>/dev/null
	docker $DOCKER_ARGS rm -f $DOCKER_NAME &>/dev/null
	docker $DOCKER_ARGS rmi -f $DOCKER_IMAGE &>/dev/null
	echo "Stopped container $DOCKER_NAME"
}

function status {
	if [[ "$(docker $DOCKER_ARGS inspect -f {{.State.Running}} $DOCKER_NAME 2>/dev/null)" == true ]] ; then
		docker $DOCKER_ARGS ps --filter "name=$DOCKER_NAME"
	else
		echo "Docker container $DOCKER_NAME is not running"
		return 1
	fi
}

function restart {
	stop
	start
}

function check_docker {
	docker $DOCKER_ARGS info &>/dev/null
}

case "$1" in
	(start|stop|status|restart)
		if check_docker ; then
			"$1"
		else
			echo "ERROR: docker daemon not running!"
			exit 1
		fi
	;;
	(*) echo "Try $0 start|status|stop|restart"
esac
