#!/bin/bash

#if [ $# -lt 1 ]; then exit 1; fi 
#echo ${@}

BASE_IMAGE=nvidia-steam
USER_UID=$(id -u)
USER_GID=$(id -g)
DNS=${DNS:-1.1.1.1}
SUDO=
STEAM_HOME=/home/steam
STEAM_LIB="/.local/share/Steam/steamapps/common/"

NVIDIA_VERSION="$(nvidia-smi -q 2> /dev/null| grep "Driver Version" | awk '{ print $4}')"
[ -z ${NVIDIA_VERSION} ] && echo "Error getting host nvidia driver information.  Please check your nvidia installation and retry." && exit 1

echo "Cleaning up stopped [${BASE_IMAGE}] instances..."
for CONTAINER_ID in $(${SUDO} docker ps -a -q); do
	IMAGE="$(${SUDO} docker inspect -f {{.Config.Image}} ${CONTAINER_ID})"
	if [ "${IMAGE}" == "${BASE_IMAGE}" ]; then
		running=$(${SUDO} docker inspect -f {{.State.Running}} ${CONTAINER_ID})
		if [ "${running}" != "true" ]; then
			echo "Removing ${CONTAINER_ID}"
			${SUDO} docker rm "${CONTAINER_ID}" >/dev/null
		fi
	fi
done

docker run -ti --ipc=host --init \
    --device /dev/nvidia-modeset --device /dev/nvidia-uvm --device /dev/nvidiactl \
    --device /dev/nvidia0 --device /dev/dri/card0 --device /dev/dri/renderD128 \
		--volume /tmp/.X11-unix:/tmp/.X11-unix \
		--volume /home/steam:/home/steam \
		--volume /home/dvinazza/${STEAM_LIB}:${STEAM_HOME}/${STEAM_LIB} \
    --volume /run/user/${USER_UID}/pulse:/run/user/1000/pulse \
    -e PULSE_SERVER=unix:/run/user/1000/pulse/native \
    -e USER_UID=${USER_UID} -e USER_GID=${USER_GID} \
    -e DISPLAY=${DISPLAY} \
    --dns ${DNS} \
		${BASE_IMAGE}:$NVIDIA_VERSION $@
