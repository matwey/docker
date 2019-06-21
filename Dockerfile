FROM opensuse/leap
MAINTAINER Matwey V. Kornilov <matwey.kornilov@gmail.com>

ENV KBUILD_OUTPUT=/build

VOLUME ["/usr/src/u-boot", "/build", "/boot"]

ENTRYPOINT ["/usr/local/bin/run.sh"]

COPY install.sh /usr/local/bin
COPY run.sh /usr/local/bin

RUN /usr/local/bin/install.sh
