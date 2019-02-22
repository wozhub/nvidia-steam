FROM tianon/steam

VOLUME /home/steam
VOLUME /home/steam/.local/share/Steam/steamapps

ENV DEBIAN_FRONTEND noninteractive
ENV SUDO sudo

#
#
# TODO: Do we really need all of these?
RUN ${SUDO} apt-get update && ${SUDO} apt-get install -y \
        apt-utils \
        mesa-utils \
        curl \
        pciutils \ 
        dbus-x11 \
    && ${SUDO} rm -rf /var/lib/apt/lists/*

#
#
# STEAM
RUN ${SUDO} apt-get update && ${SUDO} apt-get install -y \
        steam-launcher \
    && ${SUDO} rm -rf /var/lib/apt/lists/*

#
#
# NVIDIA
ARG NVIDIA_VERSION

RUN test -n "$NVIDIA_VERSION" || ( echo "Please provide nvidia driver version" && exit 1)

ADD NVIDIA-Linux-x86_64-${NVIDIA_VERSION}.run /tmp/nvidia-installer.run

RUN ${SUDO} apt-get update && ${SUDO} apt-get install -y \
        kmod \
    && ${SUDO} rm -rf /var/lib/apt/lists/* \
    && ${SUDO} sh /tmp/nvidia-installer.run -a -N --ui=none --no-kernel-module --install-libglvnd \
    && ${SUDO} rm /tmp/nvidia-installer.run


# good fonts
#COPY local.conf /etc/fonts/local.conf

#
#
# PulseAudio
# https://github.com/TheBiggerGuy/docker-pulseaudio-example/blob/master/Dockerfile
RUN ${SUDO} apt-get update && ${SUDO} apt-get install -y \
        pulseaudio-utils \
    && ${SUDO} rm -rf /var/lib/apt/lists/* 
#    && ${SUDO} gpasswd -a steam audio

# Not sure if usefull with PULSE_SERVER
# COPY pulse-client.conf /etc/pulse/client.conf

#RUN apt-get install -y /tmp/steam-installer.deb
#RUN exit 1
#RUN dpkg --add-architecture i386 && apt-get update &&  apt-get install -y \
#    libgl1-mesa-dri:i386 libgl1-mesa-glx:i386 libc6:i386 && apt-get \
#    install -y /tmp/steam.deb && sh /tmp/NVIDIA.run -a -N --ui=none --no-kernel-module


USER steam
# ENV HOME /home/steam

# ADD entrypoint.sh /entrypoint.sh

#CMD ["/entrypoint.sh"]

#RUN ${SUDO} apt-get update && ${SUDO} apt-get -y install sudo
#RUN echo "steam:steam" | chpasswd && adduser steam sudo

CMD ["steam"]
