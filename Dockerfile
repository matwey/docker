ARG VERSION=leap:15.4
FROM registry.opensuse.org/opensuse/${VERSION}
MAINTAINER Matwey V. Kornilov <matwey.kornilov@gmail.com>

ENV KBUILD_OUTPUT=/build

VOLUME ["/usr/src/linux", "/build", "/boot", "/etc/dracut.conf.d"]

ENTRYPOINT ["/usr/local/bin/run.sh"]

COPY install.sh /usr/local/bin
COPY installkernel /root/bin/installkernel
COPY run.sh /usr/local/bin

RUN /usr/local/bin/install.sh

COPY dracut.conf.d/90-network.conf /usr/lib/dracut/dracut.conf.d
COPY dracut.conf.d/90-rescue.conf /usr/lib/dracut/dracut.conf.d
COPY dracut.conf.d/95-noroot.conf /usr/lib/dracut/dracut.conf.d
COPY dracut.conf.d/95-ssh-client.conf /usr/lib/dracut/dracut.conf.d
COPY modules.d/95noroot /usr/lib/dracut/modules.d/95noroot
