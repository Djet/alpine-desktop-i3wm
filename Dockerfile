FROM alpine:3.11
ENV DISPLAY :10
ENV HOSTNAME shapeos
ENV DBUS_SYSTEM_BUS_ADDRESS unix:path=/var/run/dbus/system_bus_socket
RUN set -x \
    && apk add --update --no-cache \
          openrc=0.42.1-r2 \
          xorg-server-xnest=1.20.6-r0 \
          ttf-dejavu=2.37-r1 \
          ttf-hack=3.003-r1 \
          i3status=2.13-r2 \
          dmenu=4.9-r0 \
          setxkbmap=1.3.2-r0 \
          rxvt-unicode=9.22-r7 \
          zsh=5.7.1-r0 \
          git=2.24.1-r0 \
          vim=8.2.0-r0 \
          sudo=1.8.31-r0 \
          feh=3.3-r0 \
          dbus-openrc=1.12.16-r2 \
          dbus=1.12.16-r2 \
          chromium=79.0.3945.130-r0 \
          mesa-gl=19.2.7-r0 \
          mesa-gles=19.2.7-r0 \
          mesa-egl=19.2.7-r0 \
          mesa-dri-swrast=19.2.7-r0 \
    # add libs to chromium 
    && mkdir -p /usr/lib/chromium/swiftshader/ \
    && ln -s /usr/lib/libEGL.so.1 /usr/lib/chromium/swiftshader/libEGL.so \
    && ln -s /usr/lib/libGLESv2.so.2 /usr/lib/chromium/swiftshader/libGLESv2.so \
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
RUN DEFAULT="Xnest i3wm"; \
    for INIT in $DEFAULT; do rc-update add $INIT default; done
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/sbin/init"]
