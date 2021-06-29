FROM alpine:3.13
ENV DISPLAY :10
ENV HOSTNAME shapeos
ENV DBUS_SYSTEM_BUS_ADDRESS unix:path=/var/run/dbus/system_bus_socket
RUN set -x \
    && apk add --update --no-cache \
          openrc \
          xorg-server-xephyr \
          ttf-dejavu \
          ttf-hack \
          i3status \
          dmenu \
          setxkbmap \
          rxvt-unicode \
          zsh \
          git \
          vim \
          sudo \
          feh \
          dbus-openrc \
          dbus \
          chromium \
          mesa-gl \
          mesa-gles \
          mesa-egl \
          mesa-dri-swrast \
    # add libs to chromium 
    && apk add  --no-cache i3wm-gaps --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    # Disable getty's
    && sed -i 's/^\(tty\d\:\:\)/#\1/g' /etc/inittab \
    && sed -i \
        # Change subsystem type to "docker"
        -e 's/#rc_sys=".*"/rc_sys="docker"/g' \
        # Allow all variables through
        -e 's/#rc_env_allow=".*"/rc_env_allow="\*"/g' \
        # Start crashed services
        -e 's/#rc_crashed_stop=.*/rc_crashed_stop=NO/g' \
        -e 's/#rc_crashed_start=.*/rc_crashed_start=YES/g' \
        # Define extra dependencies for services
        -e 's/#rc_provide=".*"/rc_provide="loopback net"/g' \
        # Disable Cgroup
        -e 's/#rc_controller_cgroups=.*/rc_controller_cgroups=NO/g' \
        /etc/rc.conf \
    # Remove unnecessary services
    && rm -f /etc/init.d/hwdrivers \
            /etc/init.d/hwclock \
            /etc/init.d/hwdrivers \
            /etc/init.d/modules \
            /etc/init.d/modules-load \
            /etc/init.d/modloop \
    # Can't do cgroups
    && sed -i 's/cgroup_add_service /# cgroup_add_service /g' /lib/rc/sh/openrc-run.sh \
    && sed -i 's/VSERVER/DOCKER/Ig' /lib/rc/sh/init.sh 
COPY root/ /
RUN BOOT="hostname keymaps dbus init.persistent init.user"; \ 
    for INIT in $BOOT; do rc-update add $INIT boot; done
RUN DEFAULT="X i3wm"; \
    for INIT in $DEFAULT; do rc-update add $INIT default; done
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/sbin/init"]
