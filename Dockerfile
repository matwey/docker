FROM opensuse/leap
MAINTAINER Matwey V. Kornilov <matwey.kornilov@gmail.com>

VOLUME ["/opt/qemu"]

ENTRYPOINT ["/usr/local/bin/run.sh"]

COPY install.sh /usr/local/bin
RUN /usr/local/bin/install.sh

COPY run.sh /usr/local/bin
