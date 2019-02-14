#!/bin/bash -xe

if [ $# -lt 1 ]; then exit 1; fi 

echo ${@}

USER_UID=$(id -u)
USER_GID=$(id -g)
DNS=1.1.1.1  


docker run -ti --ipc=host --init \
    --device /dev/nvidia-modeset --device /dev/nvidia-uvm --device /dev/nvidiactl \
    --device /dev/nvidia0 --device /dev/dri/card1 --device /dev/dri/renderD129 \
    --volume /tmp/.X11-unix:/tmp/.X11-unix --volume /home/steam:/home/steam \
    --volume /run/user/${USER_UID}/pulse:/run/user/1000/pulse \
    -e PULSE_SERVER=unix:/run/user/1000/pulse/native \
    -e USER_UID=${USER_UID} -e USER_GID=${USER_GID} \
    -e DISPLAY=${DISPLAY} \
    --dns ${DNS} \
    ${@}
